Return-Path: <linux-kernel-owner+w=401wt.eu-S1761680AbXFGOg4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761680AbXFGOg4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 10:36:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756500AbXFGOgg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 10:36:36 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:25436 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389AbXFGOge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 10:36:34 -0400
Date: Thu, 7 Jun 2007 16:36:33 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Sam Ravnborg <sam@ravnborg.org>, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Another version of cleanfile/cleanpatch
In-Reply-To: <20070606191426.GT7266@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0706071634470.8762@fbirervta.pbzchgretzou.qr>
References: <20070603204700.GH9240@uranus.ravnborg.org> <20070605073335.GM7266@flower.upol.cz>
 <20070605081959.GB21991@uranus.ravnborg.org> <20070605133834.GO7266@flower.upol.cz>
 <20070605141254.GA24722@uranus.ravnborg.org> <20070605145759.GP7266@flower.upol.cz>
 <20070605151101.GQ7266@flower.upol.cz> <20070606174556.GS7266@flower.upol.cz>
 <20070606175026.GA6303@uranus.ravnborg.org> <20070606191426.GT7266@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 6 2007 21:14, Oleg Verych wrote:
>[]
>> > Many things in XXI century still can be done by tools founded 20-30
>> > years ago. Why not try to?
>> 
>> Because your shell script is unreadable by normal human beings[*]
>> while the perl script for people with a bit of perl fu can read it
>> and fix/modify it.

And because at the end of the day, the perl script might be faster
than the shell script. Yes, UNIX was designed to handle fork-exec
efficiently, thank God. But still.

>> We want tools that can be maintained and enhanced by most people.
>> 
>> [*] Normal human beings are people with same level of shell
>> scripting/sed skills that I have just to put that straight.
>
>In many cases i think, it's limiting one's imagination and expanding
>laziness[0].
>
>In the school algebra (usually) there are many exercises with
>plain-useless equations and formulas you must solve or simplify.
>Guess why? Thus my proposition. ;)
>
>---
>[0] Now, when most UNIX tools done with good quality (courtesy of the
>    GNU project), it's time not to convert programmer's laziness[1] to
>    ordinary one. Why there's one big and slow Bourne again shell, yet
>    to have fast ([d]ash) and tiny one took more time? As result more
>    efforts to remove bashizms...

I prefer bashisms over using a shell [referring to original sh or ksh]
that can't do a sane thing.

>
>[1] Ironically connected to Perl chapter of UNIX Power Tools
>    <http://unix.org.ua/orelly/unix/upt/ch37_02.htm>


	Jan
-- 
