Return-Path: <linux-kernel-owner+w=401wt.eu-S1752773AbZGLK3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752773AbZGLK3H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 06:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZGLK24
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 06:28:56 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56719 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZGLK24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 06:28:56 -0400
Date: Sun, 12 Jul 2009 12:28:47 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Daniel Walker <dwalker@fifo99.com>
Cc: greg@kroah.com, swetland@google.com, malchev@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: HTC Dream: qdsp support for staging
Message-ID: <20090712102847.GD2033@elf.ucw.cz>
References: <20090710083709.GA6418@elf.ucw.cz> <1247246757.7146.33.camel@desktop> <20090711230509.GA4705@elf.ucw.cz> <1247356604.5967.6.camel@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247356604.5967.6.camel@desktop>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2009-07-11 16:56:44, Daniel Walker wrote:
> On Sun, 2009-07-12 at 01:05 +0200, Pavel Machek wrote:
> > On Fri 2009-07-10 10:25:57, Daniel Walker wrote:
> > > On Fri, 2009-07-10 at 10:37 +0200, Pavel Machek wrote:
> > > > From: Iliyan Malchev <ibm@android.com>
> > > > 
> > > > QDSP code is neccessarry for communication with some hardware
> > > > components on HTC Dream, including camera hardware. It also drives DSP
> > > > coproccessor.
> > > > 
> > > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > 
> > > You don't want to break it up into multiple patches? I'll do it if you
> > > don't want too ..
> > 
> > I don't know how much sense it makes to split it further... yes, I
> > could probably split it per file or something but...
> > 
> > (Notice that this is going to be rewriten in staging, anyway, before
> > merging into kernel proper...)
> 
> Your expecting a full re-write? From a quick look this stuff just looks
> like it needs some TLC ..

I don't know what TLC means.

I expect a lot of changes; I did not study it in great enough detail;
but I suspect that the ammount of changes neccessary will drown any
initial changesets, so I guess it is simpler to just merge it in one piece.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
