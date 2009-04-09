Return-Path: <linux-kernel-owner+w=401wt.eu-S1763322AbZDIJFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763322AbZDIJFd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758115AbZDIJFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:05:21 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:35274 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759390AbZDIJFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:05:19 -0400
Date: Thu, 09 Apr 2009 16:39:52 +0800
From: fangxiaozhi 00110321 <huananhu@huawei.com>
Subject: The problems for driver module loading
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de, greg@kroah.com
Message-id: <fad7ab4fac82c.ac82cfad7ab4f@huawei.com>
MIME-version: 1.0
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
Content-type: text/plain; charset=us-ascii
Content-language: zh-CN
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-Accept-Language: zh-CN
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All:

   I am sorry, I want to know is there the feature of priority (PRI) for kernel driver loading in Linux, such as in Windows or Mac OS.

   I develop an independent ECM driver for our standard ECM ether device. And then I install it on some Linux system, such as OpenSUSE 11.0 or Fedora 10. 

   But in these systems, they also have a built-in ECM driver cdc_ether.ko. So, while I plug in our device, then the system often attaches cdc_ether.ko driver for our device, but not attaching ours.

   Because cdc_ether.ko driver can not support our QMI protocol, so we want the Linux system can always attach our driver to our device, but not cdc_ether.ko driver.

   How can I do for this? 

   Wait for your help, thanks.

Best Regards,

Franko Fang
2009-4-9

******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
