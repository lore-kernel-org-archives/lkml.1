Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbZKSIIq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbZKSIIq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 03:08:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZKSIIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 03:08:46 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:40103 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639AbZKSIIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 03:08:45 -0500
Date: Thu, 19 Nov 2009 09:08:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>, San Mehat <san@google.com>,
       Iliyan Malchev <malchev@google.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: Status of Dream series
Message-ID: <20091119080845.GB30454@elf.ucw.cz>
References: <20091111104748.GA26975@elf.ucw.cz>
 <1258135899.6411.7.camel@c-dwalke-linux.qualcomm.com>
 <20091118170238.GE20887@elf.ucw.cz>
 <1258537122.8014.2.camel@ubuntu>
 <20091118181824.GK25150@elf.ucw.cz>
 <1258540955.8014.4.camel@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258540955.8014.4.camel@ubuntu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-11-18 10:42:35, Daniel Walker wrote:
> On Wed, 2009-11-18 at 19:18 +0100, Pavel Machek wrote:
> > Hi!
> > 
> > > > > > Russell, what is the status of the "Dream" series? 
> > > > > > 
> > > > > >  [PATCH 1/3] msm: make debugging UART (for DEBUG_LL) configurable
> > > > > >  [PATCH 2/3] msm: add minimal board file for HTC Dream device
> > > > > >  [PATCH 3/3] msm: Add memory map for HTC Dream
> > > > > > 
> > > > > > Daniel Walker offered to maintain arch-msm tree, would that help? 
> > > > > 
> > > > > Yeah, I can do it for now, but I can't accept patches for it via this
> > > > > email address.. I'm in the processes of setting up the right address for
> > > > > it .. Might take till next week tho.
> > > > 
> > > > Ok, can I just add your acked-by, and send them to akpm/rmk? These
> > > > three are simple enough...
> > > 
> > > Didn't Russell have some pending comments? Anyway, I have them already
> > > in my korg git tree. So I can move them forward from there , but it's
> > > temporary ..
> > 
> > Here's fixed #2. I guess we can add rmk's reviewed-by (and yours?) and
> > send them forward?
> 
> I'll add my sign off, put them into my git tree (which is included in
> linux-next) , the eventually push them to Linus when the merge window
> opens ..

Thanks! You should probably add yourself into the MAINTAINER file, too...

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
