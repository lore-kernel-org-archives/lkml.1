Return-Path: <linux-kernel-owner+w=401wt.eu-S1753505AbYIXDNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbYIXDNK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 23:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751645AbYIXDMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 23:12:55 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21829 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYIXDMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 23:12:55 -0400
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2008 23:12:55 EDT
Date: Wed, 24 Sep 2008 11:02:52 +0800
From: Franko Fang <huananhu@huawei.com>
Subject: Re: [PATCH 10/4]linux-usb: To support more Huawei data card	product
 IDs, fix kernel 2.6.26.5
To: Greg KH <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, zihan@huawei.com,
       Lin.Lei@huawei.com, zhangqianchun@huawei.com
Message-id: <019701c91df2$08d1d430$f9100b0a@china.huawei.com>
MIME-version: 1.0
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3350
X-Mailer: Microsoft Outlook Express 6.00.2900.3138
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 7BIT
X-Priority: 3
X-MSMail-priority: Normal
References: <faf7c9cb3c6f0.3c6f0faf7c9cb@huawei.com>
 <20080924023053.GA24846@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Greg KH,

 I am sorry, but I can only get the newest version from http://www.kernel.org/pub/linux/kernel/ is 2.6.26.5.

 Can you tell me the link to download 2.6.27-rc7 ?

  Thanks very much.

Best Regards,
Franko Fang
2008-9-24
----- Original Message ----- 
From: "Greg KH" <greg@kroah.com>
To: "fangxiaozhi 00110321" <huananhu@huawei.com>
Cc: <linux-usb@vger.kernel.org>; <linux-kernel@vger.kernel.org>; <zihan@huawei.com>; <Lin.Lei@huawei.com>; <zhangqianchun@huawei.com>
Sent: Wednesday, September 24, 2008 10:30 AM
Subject: Re: [PATCH 10/4]linux-usb: To support more Huawei data card product IDs, fix kernel 2.6.26.5


> On Wed, Sep 24, 2008 at 10:07:31AM +0800, fangxiaozhi 00110321 wrote:
>> 
>> From: fangxiaozhi <huananhu@huawei.com>
>> 
>> 1. This patch is based on the kernel of 2.6.26.5
> 
> Can you rebase this on 2.6.27-rc7 instead?  Lots of device ids have been
> added to this driver since 2.6.26.5
> 
>> 2. To declare the unusual device for new Huawei data card devices in unusual_devs.h
>> 3. To modify the data value and length in the function of usb_stor_huawei_e220_init in initializers.c
>> 4. To declare more new product IDs in option.c.
> 
> This should be split up into 4 different patches, as it does 4 different
> things.  Care to redo it please?
> 
> thanks,
> 
> greg k-h
