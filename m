Return-Path: <linux-kernel-owner+w=401wt.eu-S934969AbZLGKHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934969AbZLGKHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 05:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934938AbZLGKHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 05:07:05 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53875 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934893AbZLGKHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 05:07:04 -0500
Date: Mon, 7 Dec 2009 11:07:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Brian Swetland <swetland@google.com>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Daniel Walker <dwalker@codeaurora.org>,
       Iliyan Malchev <malchev@google.com>
Subject: Re: HTC Dream: dream is better name for this machine
Message-ID: <20091207100703.GF23088@elf.ucw.cz>
References: <20091206205041.GA12555@elf.ucw.cz>
 <a55d774e0912061527t5b09b510g1fc458b53a423c04@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a55d774e0912061527t5b09b510g1fc458b53a423c04@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2009-12-06 15:27:38, Brian Swetland wrote:
> On Sun, Dec 6, 2009 at 12:50 PM, Pavel Machek <pavel@ucw.cz> wrote:
> >
> > While few people may know HTC Dream by its codename, it is better to
> > use name of released hardware in the sources.
> 
> I still think that it'd be less pain for everyone to leave it as
> trout.  If you go by sales volume, the most known released hardware
> name is "Tmobile G1", some people know it as ADP1, and I believe it
> has sold under a few other names in other markets, but the software

Yes, operators brand their handsets. Unfortunately g1/adp1 names suck
-- for being alphabet soups -- and HTC Dream *is* name of the
hardware.

http://en.wikipedia.org/wiki/HTC_Dream

(and it is certainly better name than trout).

> has, since day one, been trout and changing that just makes it harder
> to merge other existing changes where we'd have to deal with renames
> as well.  The bootloader identifies it as "trout", and the userspace
> software stack's hardware-specific bits refer to trout.

Well, the longer we wait, the harder it will be to change the nema...

> If it really drives everyone crazy, we could do a big rename once it's
> all in and working, but right now I just don't see the benefit.

It is normally better to change such stuff before merging to
mainline. Splitting/cleaning patches is generally enough work that
little renaming should not be huge problem. 
									Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
