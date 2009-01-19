Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbZASTON@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbZASTON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 14:14:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbZASTNm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 14:13:42 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41375 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339AbZASTNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 14:13:41 -0500
Date: Mon, 19 Jan 2009 16:02:20 +0100
From: Pavel Machek <pavel@suse.cz>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: kernel list <linux-kernel@vger.kernel.org>, rpurdie@rpsys.net
Subject: Re: introduce delayed-leds.h to reduce code duplication
Message-ID: <20090119150219.GA6463@ucw.cz>
References: <20090111224331.GA28010@elf.ucw.cz> <20090112100500.GA31656@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090112100500.GA31656@khazad-dum.debian.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2009-01-12 08:05:01, Henrique de Moraes Holschuh wrote:
> On Sun, 11 Jan 2009, Pavel Machek wrote:
> > What about something like this? 
> > 
> > [Alternatively, I can add a flag to the leds class, and make delayed
> > leds a built-in functionality...]
> > 
> > [Attached is driver that uses new infrastructure for hp_accel, but it
> > does a bit more.]
> 
> FWIW, I am looking over the thinkpad-acpi side of this.  I like the idea,
> but I am not completely sure I agree fully with the changes to
> thinkpad-acpi.
> 
> Which isn't a problem, as long as the thinkpad-acpi hunks are NOT merged to
> any tree before my ACK, please.  I will test and comment on the patch before
> the weekend.

Any news?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
