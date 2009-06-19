Return-Path: <linux-kernel-owner+w=401wt.eu-S1759482AbZFSCld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759482AbZFSCld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758899AbZFSClP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:41:15 -0400
Received: from [61.155.106.76] ([61.155.106.76]:54236 "EHLO www.mid-fun.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754647AbZFSClP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:41:15 -0400
Subject: Re: about X and VT_WAITACTIVE
From: tommy <jiujin.hong@mid-fun.com>
To: linux-arm-kernel@lists.arm.linux.org.uk,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1245377698.7144.3.camel@tommy-desktop>
References: <1245377698.7144.3.camel@tommy-desktop>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2009 10:41:14 +0800
Message-Id: <1245379274.7144.5.camel@tommy-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,all !

i have found this patch in
http://kerneltrap.org/mailarchive/linux-kernel/2007/5/30/97252!
i think its codestyle is better than former!

anyone agree ?
On 五, 2009-06-19 at 10:14 +0800, tommy wrote:
> hi,Dear Sir!
> 
> First thanks to your patch by
> http://forum.soft32.com/linux/PATCH-vt-fix-potential-race-VT_WAITACTIVE-handler-ftopict341520.html!
> 
> But Now I also met this question by VT_WAITACTIVATE!
> 
> My board is S3C6410 ARM11,Xorg-server-1.3.0.0,linux 2.6.24 
> 
> linux/driver/char/vt_ioctl also have your patch code for
> VT_WAITACTIVATE.
> 
> I met VT_WAITACTIVATE question by 3/50 testing my rootfs on ARM11
> S3C6410.
> 
> How can i fix this ?thanks !

