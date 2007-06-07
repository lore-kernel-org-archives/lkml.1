Return-Path: <linux-kernel-owner+w=401wt.eu-S936348AbXFGC2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936348AbXFGC2T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 22:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935371AbXFGC2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 22:28:11 -0400
Received: from mail4.webhostingstar.com ([67.106.77.50]:59350 "HELO
	mail4.webhostingstar.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759933AbXFGC2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 22:28:10 -0400
Message-ID: <20070606212643.36m4bgcq8ssc4o84@67.106.77.50>
Date: Wed, 06 Jun 2007 21:26:43 -0500
From: art@usfltd.com
To: linux-kernel@vger.kernel.org
Cc: torvalds@osdl.org, greg@kroah.com, michal.k.k.piotrowski@gmail.com
Subject: Re: usb-scanner-cameras kernel-2.6.22 and udev-095 problem
MIME-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

greg this is part of my config
(we are talking now 2.6.22-rc4-200706042030-cfq7 #160 SMP PREEMPT Mon  
Jun 4 20:55:02 CDT 2007 x86_64 x86_64 x86_64 GNU/Linux)

CONFIG_USB_DEVICEFS=y
# CONFIG_USB_DEVICE_CLASS is not set ---------------------
# CONFIG_USB_DYNAMIC_MINORS is not set
CONFIG_USB_SUSPEND=y
# CONFIG_USB_OTG is not set

i disabled libusual in my config
# CONFIG_USB_LIBUSUAL is not set
with libusual=y my usb-harddrives doesn't show up on desktop after  
boot until i cycle one off/on and from this moment all of them start  
showing up
with libusual not set -usb-harddrives shows up but this doesn't affect  
scanners

btw scanners are working with standard fc7 86-x64 kernel

xboom
