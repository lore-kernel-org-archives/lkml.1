Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478AbXKASDj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478AbXKASDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:03:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753058AbXKASDb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:03:31 -0400
Received: from sccrmhc11.comcast.net ([63.240.77.81]:35057 "EHLO
	sccrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611AbXKASDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:03:30 -0400
Subject: Re: Issue building kernel driver
From: Chris Holvenstot <cholvenstot@comcast.net>
To: Adrian Bunk <bunk@kernel.org>, kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20071101175126.GA7227@stusta.de>
References: <1193938746.7555.7.camel@localhost>
	 <20071101175126.GA7227@stusta.de>
Content-Type: text/plain
Date: Thu, 01 Nov 2007 13:03:37 -0500
Message-Id: <1193940217.7555.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Thank you for the quick response - normally I would not have bothered
with the kernel list but this is a case where the same source would
sucessfully compile on "git4" but not on "git9 or git10"

As I previously stated the message is also being sent to the VirtualBox
developers (who will likely tell that they don't support those who build
and test development kernels)

Once again thanks





On Thu, 2007-11-01 at 18:51 +0100, Adrian Bunk wrote:
> On Thu, Nov 01, 2007 at 12:39:06PM -0500, Chris Holvenstot wrote:
> > Adrian Bunk <bunk@kernel.org>Adrian Bunk <bunk@kernel.org>
> > Although it may not be popular with the crowd here, I do have a valid
> > reason to run Windows - and I accomidate this using the VirtualBox
> > product.  
> > http://www.google.com/
> > Since I try to be slightly useful and build as many of the "test" kernel
> > images I can I end up rebuilding the VirtualBox kernel driver (open
> > source) on an almost daily basis.
> >...
> > I am not sure if this should be reported to the kernel folks or the
> > VirtualBox folks - but the kernel code is what changed.  However I will
> > post this on the VirtualBox forum too.
> 
> We had a (different) bug report involving exactly this external driver 
> at some older post 2.6.23 kernel where it turned out it was a problem in 
> this driver - and this one also looks really like a problem in their 
> driver.
> 
> Generally, problems with external drivers should be reported to the 
> vendors of these drivers and not here (unless it's clear it's a bug in 
> the kernel and not in the driver).
> 
> > Thanks
> 
> cu
> Adrian
> 

