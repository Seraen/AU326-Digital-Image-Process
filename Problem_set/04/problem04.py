import cv2
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from skimage import data,filters,segmentation,measure,morphology,color
import os

# bwareaopen function to remove regions of small areas from the image
def bwareaopen(image,size):
    output=image.copy()
    nlabels, labels, stats, centroids = cv2.connectedComponentsWithStats(image)
    for i in range(1,nlabels-1):
        regions_size=stats[i,4]
        if regions_size<size:
            x0=stats[i,0]
            y0=stats[i,1]
            x1=stats[i,0]+stats[i,2]
            y1=stats[i,1]+stats[i,3]
            for row in range(y0,y1):
                for col in range(x0,x1):
                    if labels[row,col]==i:
                        output[row,col]=0
    return output

# find the largest connected domain
def find_the_connected_domain(im):
    segmentation.clear_border(im)
    label_image = measure.label(im)
    max_region_area = 0
    area = {}
    # get every connected region
    for region in measure.regionprops(label_image):
        if region.area > max_region_area:
            max_region = region
            max_region_area = region.area
            area[region.area] = region
        else:
            area[region.area] = region
            continue
    handled_area = sorted(list(area.keys()))
    handled_area.reverse()
    # find the max region
    max_region = area[handled_area[0]]
    return max_region

# handle the situation of overlapping
def coverage_handle(coverage_im):
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (20, 20))
    im = cv2.dilate(coverage_im, kernel)
    im_copy1=im.copy()
    im_copy2 =im.copy()
    cv2.imwrite('coverage_im.jpg',im)

    # the connected contours
    o, contours, hierarchy = cv2.findContours(im, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
    cv2.drawContours(img_copy, contours, -1, (0, 255, 255), 2)
    # find the max and second max region
    area_res = []
    for i in range(len(contours)):
        area_res.append(cv2.contourArea(contours[i]))
    max_idx = np.argmax(area_res) # the max
    second_idx=0
    for i1 in range(len(contours)):
        if i1==max_idx:
            continue
        else:
            if area_res[i1]>area_res[second_idx]:
                second_idx=i1 # the second max
            else:
                continue
    # leave only the max or second max region in the image
    im_copy1=bwareaopen(im_copy1,area_res[max_idx])
    cv2.fillConvexPoly(im_copy2, contours[max_idx], 0)
    im_copy2 = bwareaopen(im_copy2,area_res[second_idx])
    # dilation
    kernel1 = cv2.getStructuringElement(cv2.MORPH_RECT, (120, 120))
    kernel2 = cv2.getStructuringElement(cv2.MORPH_RECT, (200, 200))
    im_copy1 = cv2.dilate(im_copy1, kernel1)
    im_copy2 = cv2.dilate(im_copy2, kernel2)
    cv2.imwrite('copy1.jpg', im_copy1)
    cv2.imwrite('copy2.jpg', im_copy2)
    # draw the rectangle
    max_region=find_the_connected_domain(im_copy1)
    second_max_region=find_the_connected_domain(im_copy2)
    minr1, minc1, maxr1, maxc1 = max_region.bbox
    minr2, minc2, maxr2, maxc2 = second_max_region.bbox
    cv2.rectangle(img1, (minc1, minr1), (maxc1, maxr1), (0, 0, 255), 4)
    cv2.rectangle(img1, (minc2, minr2), (maxc2, maxr2), (0, 0, 255), 4)
    return img1

# the main function
images=['1edge.png','2diagonal.png','3cap1.png','4hands.png','5handsdown.png',
        '6righthand.png','7twoboards.png','8screwdriver.png','9righttopcorner.png',
        '10lefthand1.png','11lefthand2.png','12screwtoolbox.png','13cap2.png']
for k in range(len(images)):
    image=cv2.imread(images[k])
    img1=image.copy()
    img_copy=image.copy()
    lower_blue=np.array([100,47,47])
    upper_blue=np.array([124,255,255])
    # mask
    mask=np.zeros([img1.shape[0],img1.shape[1]],np.uint8)
    mask[img1.shape[0] // 5:img1.shape[0] // 5*4, img1.shape[1] //5:img1.shape[1] // 5*4] = 1
    masked=cv2.bitwise_and(img1,img1,mask=mask)   # Bitwise-AND Operator for the template and the original image
    cv2.imwrite('masked.jpg',masked)
    # extract the blue channel
    frame=cv2.cvtColor(masked,cv2.COLOR_BGR2HSV)
    mask_blue=cv2.inRange(frame,lower_blue,upper_blue)
    res_blue=cv2.bitwise_and(frame,frame,mask=mask_blue)
    res_blue=cv2.cvtColor(res_blue,cv2.COLOR_HSV2BGR)
    cv2.imwrite('./mask_blue/'+str(k+1)+'.jpg',mask_blue)
    cv2.imwrite('./res_blue/'+str(k+1)+'.jpg',res_blue)
    # dilation
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (100, 100))
    dst = cv2.dilate(mask_blue,kernel)
    cv2.imwrite('./dst/'+str(k+1)+'.jpg',dst)
    # find the contours of dilated images
    gray_temp = dst.copy()
    o,contours, hierarchy = cv2.findContours(dst, cv2.RETR_TREE, cv2.CHAIN_APPROX_NONE)
    # show the contours of the input image
    cv2.drawContours(img_copy, contours, -1, (0, 255, 255), 2)
    cv2.imwrite('./contours/'+str(k+1)+'.jpg',img_copy)

    # find the max area of all the contours and fill it with 0
    area = []
    for i in range(len(contours)):
        area.append(cv2.contourArea(contours[i]))
    max_idx = np.argmax(area)

    # get connected regions
    segmentation.clear_border(dst)
    label_image =measure.label(dst)
    max_region_area=0
    for region in measure.regionprops(label_image):
        if region.area>max_region_area:
            max_region=region
            max_region_area=region.area
        else:
            continue
    # draw the rectangle
    minr, minc, maxr, maxc = max_region.bbox
    print(maxr-minr,' ',maxc-minc)
    # handle boardness and offset
    if maxr-minr>410:
        coverage_handle(mask_blue)
    else:
        if maxc-minc>1.2*(maxr-minr):
            cv2.rectangle(img1, (minc, minr), (maxc, maxr), (0,0,255), 4)
        else:
            cv2.rectangle(img1, (minc, minr), (int(minc+1.5*(maxc-minc)), maxr), (0, 0, 255), 4)

    cv2.imwrite('./result/'+str(k+1)+'.jpg',img1)
    #fig,(ax0,ax1)= plt.subplots(1,2,figsize=(8,6))
    #ax0.imshow(dst,plt.cm.gray)
    #ax1.imshow(img1[:,:,(2,1,0)])
    #plt.show()
