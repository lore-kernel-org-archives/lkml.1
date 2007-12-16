Return-Path: <linux-kernel-owner+w=401wt.eu-S1759619AbXLPVFD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759619AbXLPVFD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 16:05:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757198AbXLPVEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 16:04:55 -0500
Received: from fmmailgate04.web.de ([217.72.192.242]:33217 "EHLO
	fmmailgate04.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbXLPVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 16:04:54 -0500
Date: Sun, 16 Dec 2007 22:04:51 +0100
Message-Id: <49547705@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Parag Warudkar <parag.warudkar@gmail.com>
Cc: Matt_Domsch@dell.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] be more verbose when probing EDD
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX199cfJap9w9HN0C/OeHqoi0Dce3/2pemgpM0JRN3lnwE1wsl
 tw9I92nNv+vXdPt0yo0fRsO1ZpT51Djcpo03VMoEfa2MG62710=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > not sure if really all of them are the edd problem i have, but i`m quite sure for some of those.
> > can provide more links if somebody likes.
> 
> None of them seemed like they were determined as EDD problems - 

so - see how difficult it is to determine, what`s the problem is ? ;)

>some even did not work with edd=skipmbr.

on my 2 problematic systems, edd=skipmbr doesn`t help. only edd=off helps. 

> But that is not the point. Problem is not widely known, likely happens
> with very old BIOSes and people who use those systems should be
> knowing more than simply booting back to Win98.

i don`t see any relation to what a user knows and what kind of system of what age he is using.


> And if those people are smart enough to figure out the right place to
> ask - they will likely get suggestions to do edd=off like some of the
> above links that you posted prove - without the message.

see - and THATS where our opinion probably differs very much from mine. 
i think, user`s don`t want an operating system at all.
they want that their computer just works and that they can use their apps.
us linux fans have fun with debugging things and make them work,helping others and that stuff - but others just don`t want to search for the magic token to make their computer boot. if windows just boots on that system, so should linux. if it doesn`t, they should be able to fix this without being an expert.

> Why tax other people with a warning/hang etc. in printk when the
> problem is very unlikely on their systems?

i don`t have a clue how likely or unlikely the problem is. i have seen that problem more than once and i know people who also can tell you about.

> So you think those people with such low tech knowledge will figure out
> the right mailing list, make sense of the output of EDD message and
> then post the question? Or that they will figure out how to specify
> the edd=off to kernel command line? In that use case - not doing EDD
> on their boxes like I said would be the most useful thing to do. A
> message or 3 is useless in this case.

at least they could get help by any other linux user with average experience.
but a blinking cursor in the upper left is nothing an average linux user is being able to implicate with EDD.

> But yeah whatever - if you cut it down to one printk line and remove
> the hang word that would at least be bearable :)

ok. i think i`m making to much noise for too few lines of code, so let`s stop discussing.
but let`s wait for some more comments.
maybe some simple "probing edd" is a diplomatic solution and at least better than nothing. 

regards
roland


_____________________________________________________________________
Der WEB.DE SmartSurfer hilft bis zu 70% Ihrer Onlinekosten zu sparen!
http://smartsurfer.web.de/?mc=100071&distributionid=000000000066

