Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbYJ3QQ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbYJ3QQ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:16:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753482AbYJ3QQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:16:46 -0400
Received: from hades.rz.tu-clausthal.de ([139.174.2.20]:53234 "EHLO
	hades.rz.tu-clausthal.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbYJ3QQp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:16:45 -0400
From: Volker Armin Hemmann <volker.armin.hemmann@tu-clausthal.de>
To: Greg KH <greg@kroah.com>
Subject: Re: 2.6.27: ehci bug with AMD 770nb/SB700 southbridge. usb lockup
Date: Thu, 30 Oct 2008 17:16:39 +0100
User-Agent: KMail/1.10.90 (Linux/2.6.27.4r4; KDE/4.1.71; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Libin.Yang@amd.com, Crane Cai <crane.cai@amd.com>
References: <200810300215.18792.volker.armin.hemmann@tu-clausthal.de> <20081030055410.GB19035@kroah.com>
In-Reply-To: <20081030055410.GB19035@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810301716.39839.volker.armin.hemmann@tu-clausthal.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Donnerstag 30 Oktober 2008, Greg KH wrote:
Hi,
thanks for your answer. 

>
> This chipset was known to have bugs in it, which I think we fixed
> already.  I have a laptop with this chipset and it can sustain large
> ammounts of USB data just fine with the 2.6.27 kernel series, so I
> wonder if something is wrong with your usb disk drive?


as I wrote - it happens with several different enclosures.

1 containing a dvd-rw drive
1 containing ide disks - tried two different disks in this one
1 from a friend containing an ide disk, working well with his systems.
1 from the same friend containing a 2,5" drive and a y-cable,

That are four different enclosures and 5 different drives that are 
problematic. I thought that it might be the 4 port hub, but if I disconnect it 
and put in the mouse receiver directly the same things are happening. I also 
tried different ports, it is always the same.

Glück Auf
Volker

