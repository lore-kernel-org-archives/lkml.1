Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJGTzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJGTzX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 15:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753768AbYJGTzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 15:55:11 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:60310 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbYJGTzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 15:55:10 -0400
Date: Tue, 7 Oct 2008 21:56:48 +0200
From: Pavel Machek <pavel@suse.cz>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH V3] led: Backlight trigger for led subsystem
Message-ID: <20081007195648.GD6604@elf.ucw.cz>
References: <1223374230-18413-1-git-send-email-giometti@enneenne.com> <20081007135420.GB1592@ucw.cz> <20081007152032.GH13035@tekkaman> <20081007185846.GA6604@elf.ucw.cz> <20081007192112.GL13035@tekkaman>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081007192112.GL13035@tekkaman>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2008-10-07 21:21:12, Rodolfo Giometti wrote:
> On Tue, Oct 07, 2008 at 08:58:46PM +0200, Pavel Machek wrote:
> > 
> > Ok, what is it good for? So I have backlight, charging led and hdd led
> > on my zaurus. Now I can set charging led to indicate backlight... but
> > why is it useful?
> 
> On my board, for example, I have a led for each "special" buttons and
> others to indicate to the user some "special" conditions of machine
> internals. All these leds should be switched off each time the LCD
> blanks and they should get their old brightness status when the LCD
> unblanks.

Hmm, what's "your board"?

But ok, I guess that makes some sense, additionally it would be useful
for keyboard backlight...

In fact, thinkpad light should probably behave like that, too...
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
