Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbZF2WQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbZF2WQ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbZF2WQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:16:52 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:50725 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbZF2WQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:16:51 -0400
Date: Tue, 30 Jun 2009 00:16:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: San Mehat <san@google.com>, kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>,
       pierre@ossman.eu, Andrew Morton <akpm@osdl.org>
Subject: Re: MMC driver for HTC Dream
Message-ID: <20090629221648.GA12179@elf.ucw.cz>
References: <20090629214101.GA12043@elf.ucw.cz> <20090629214610.GB16981@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090629214610.GB16981@google.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-06-29 14:46:10, Brian Swetland wrote:
> [Pavel Machek <pavel@ucw.cz>]
> > From: San Mehat <san@android.com>
> > 
> > MMC Driver for HTC Dream. I picked the code up from Google git trees,
> > removed stuff not strictly neccessary, and did a bit of cleanups. It
> > still works :-).
> 
> Hi Pavel,
> 
> I'm looping in San, who wrote the driver.  Thanks a ton for doing all
> this work to help clean stuff up and push toward mainline.  Could you
> include the original driver authors (the git history should show them
> and often they're mentioned in an Author: line under the copyright/
> license banners) on to: or cc: when you send out patches?  

Oops, I put San in From: (which should give him proper credit) but
forgot to add him to Cc list. Sorry.

> I forwarded the original mail to San so he should have this patch
> intact.

Thanks!
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
