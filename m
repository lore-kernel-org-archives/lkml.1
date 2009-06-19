Return-Path: <linux-kernel-owner+w=401wt.eu-S1757129AbZFSCVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbZFSCVr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:21:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752933AbZFSCVj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:21:39 -0400
Received: from [61.155.106.76] ([61.155.106.76]:54043 "EHLO www.mid-fun.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752713AbZFSCVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:21:39 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 22:21:38 EDT
Subject: about X and VT_WAITACTIVE
From: tommy <jiujin.hong@mid-fun.com>
To: spock.DeleteThis@gentoo.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Fri, 19 Jun 2009 10:14:58 +0800
Message-Id: <1245377698.7144.3.camel@tommy-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,Dear Sir!

First thanks to your patch by
http://forum.soft32.com/linux/PATCH-vt-fix-potential-race-VT_WAITACTIVE-handler-ftopict341520.html!

But Now I also met this question by VT_WAITACTIVATE!

My board is S3C6410 ARM11,Xorg-server-1.3.0.0,linux 2.6.24 

linux/driver/char/vt_ioctl also have your patch code for
VT_WAITACTIVATE.

I met VT_WAITACTIVATE question by 3/50 testing my rootfs on ARM11
S3C6410.

How can i fix this ?thanks !

