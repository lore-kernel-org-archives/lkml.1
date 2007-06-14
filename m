Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXFNMld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXFNMld (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 08:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751473AbXFNMl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 08:41:26 -0400
Received: from mx.laposte.net ([81.255.54.16]:25453 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303AbXFNMlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 08:41:25 -0400
Message-ID: <14051.192.54.193.51.1181824859.squirrel@rousalka.dyndns.org>
Date: Thu, 14 Jun 2007 14:40:59 +0200 (CEST)
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
From: "Nicolas Mailhot" <nicolas.mailhot@laposte.net>
To: "Daniel Hazelton" <dhazelton@enter.net>
Cc: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc7
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Since everyone is having fun, and the kernel includes a few bytes from
yours truly, I figured I could state my opinion too.

1. Linus' "clarifications" of GPL2-only may apply to the kernel work
as a whole, and to patches submitted from the clarification moment,
but not to the individual patches submitted before. A lot of noise is
made about dead author wishes but nobody seems to care about the
wishes of live authors who may not have a hard GPL2-only stance and
have been retroactively tagged GPLv2-only supporters. (that's for all
the diatribes about the evil FSF unduly speaking for others)

2. Seems there are enough GPLv3 supporters to do the heavy legwork and
get clear statements about licensing status of past code submissions
should the  core kernel hackers agree to GPLv3 licensing. So a
licensing change is technically possible

Daniel Hazelton wrote:
> And this is what the FSF, RMS and yes, *YOU*, Alexandre, fail to
realize
> - the GPL covers *ONLY* the software. It has *ZERO* legal standing when
> applied to hardware.

And drm keys are hardware? Nope, they're a string of bytes. Looks like
software to me.

You're the one who's confusing hardware with software, and trying to
apply software legal rules (limited usage rights) to hardware. No law
forbids taking hardware you bought and modifying it outside the
original manufacturer control (including crazy things like turning
cars in boats or planes). In fact many laws especially target attempts
to restrict modification to "blessed" original manufacturer parts
(I'll intentionaly skip over recent creative lawmaking which confused
everyone including the people who rubber-tamped lobby texts)

That may suck but while you can technicaly substitute a cheaper
software implementation to a hardware one, they are not covered by the
same laws. You have a technical continuum but not a legal continuum.

Your software substitute is going to be subject to the software legal
corpus. That means licensing limits. If you wrote your own code you
can use whatever restrictive software license you want. If you didn't
you have to abide with the original author licensing, which may be
something like the GPLv3 that forbids you to extend software
restrictions to hardware (and one is not more amoral than the other)

GPLv3 only controls the software part of the equation. You can still
manufacture hardware however you want. What you can't do any longer is
use software and software exclusive licensing terms to control
hardware (Bear in mind even if you sold a device with a physicaly
welded hood the law allows the buyer to take a hammer and crack it
open. Legal manufacturer control just does not exist past this point.
That should tell you who is crossing the lines in the drm case).

You may still limit modifications if you don't sell a device but rent
it, but many tivo-ing entities around the world want to eat their cake
and keep it by selling hardware and using drm to lock it (trying to
apply software rules to hardware)

If the GPLv3 actually tried to use copyright law to control hardware,
it wouldn't stand in court.

-- 
Nicolas Mailhot

