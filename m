Return-Path: <linux-kernel-owner+w=401wt.eu-S1762594AbXFBV7Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762594AbXFBV7Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 17:59:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757053AbXFBV7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 17:59:08 -0400
Received: from ns2.g-housing.de ([81.169.133.75]:50038 "EHLO mail.g-house.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671AbXFBV7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 17:59:07 -0400
Date: Sat, 2 Jun 2007 22:59:01 +0100 (BST)
From: Christian Kujau <lists@nerdbynature.de>
X-X-Sender: evil@sheep.housecafe.de
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
Message-ID: <alpine.DEB.0.99.0706022253130.16496@sheep.housecafe.de>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2007, Justin Piszcz wrote:
> Wondering as their were a lot of XFS related issues early on in 
> development..?  The 2.6.22-rc3 kernel has the core 2 duo coretemp patch by 
> ruik which I want be running as long as 2.6.22-rc3 does not have any severe 
> XFS issues?

Tracking -rc and running 2.6.22-rc3 for a couple of days now, no 
problems with xfs since this infamous 2.6.17 thingy[0]. But that's 
pretty useless information I guess, since your setup will be different 
from mine. Did you have anything "special" in mind when asking this?

C.

[0] http://oss.sgi.com/projects/xfs/faq.html#dir2
-- 
BOFH excuse #339:

manager in the cable duct
