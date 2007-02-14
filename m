Return-Path: <linux-kernel-owner+w=401wt.eu-S932227AbXBNMaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932227AbXBNMaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 07:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932234AbXBNMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 07:30:23 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:34915 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932228AbXBNMaW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 07:30:22 -0500
Date: Wed, 14 Feb 2007 13:00:40 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Theodore Tso <tytso@mit.edu>, Greg KH <greg@kroah.com>,
       Nicolas Mailhot <nicolas.mailhot@laposte.net>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070214120040.GA23857@elf.ucw.cz>
References: <32793.192.54.193.51.1170248792.squirrel@rousalka.dyndns.org> <20070131201258.GB15128@kroah.com> <20070131230014.GD20514@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070131230014.GD20514@thunk.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > This kind of offer has _always_ been there for out-of-tree GPL drivers.
> > I have contacted many different groups and driver authors over the years
> > to offer my help in trying to get their code into the mainline kernel.
> > 
> > Some take me up on the offer, others ignore it, and still others activly
> > refuse to do so, saying they want to stay out-of-the tree (lirc is one
> > of these examples...)
> 
> I think the point is that if we are offering free development effort
> to write a driver which goes into mainline, maybe we should provide
> more than "providing rules and guidelines" so that people can spend
> engineering $$$ to get the driver into mainline.   
> 
> More specifically, Dave said that it "seemed rude" to just take the
> driver and send updates, but maybe the best way of dealing with
> out-of-tree drivers like lirc is to treat the out-of-tree drivers as a
> kind of spec release, and just have someone in the community forcibly
> take the code, fix it up, and then get it merged.  Maybe it's being
> "rude", but so is not responding to requests to get it merged.

So can I treat Shem's code as a spec release, and merge it? :-).

[Okay, so your position is more reasonable than expected, good; but
signed-off process strongly discourages merging some code without
author's cooperation.]
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
