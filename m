Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbYA3VBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbYA3VBS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 16:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752710AbYA3VA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 16:00:59 -0500
Received: from mail1.webmaster.com ([216.152.64.169]:2335 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYA3VA6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 16:00:58 -0500
From: "David Schwartz" <davids@webmaster.com>
To: =?utf-8?Q?M=C3=A5ns_Rullg=C3=A5rd?= <mans@mansr.com>
Cc: "Adrian Bunk" <bunk@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: ndiswrapper and GPL-only symbols redux
Date: Wed, 30 Jan 2008 13:00:50 -0800
Message-ID: <MDEHLPKNGKAHNMBLJOLKCEDPJPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <Pine.LNX.4.64.0801300836030.12371@anakin>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 30 Jan 2008 13:02:12 -0800
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 30 Jan 2008 13:02:14 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Combined reponses to many fragmented comments in this thread. No two consecutive excerpts are from the same person.

> Interesting... I never heard about this `transferring ownership of a
> single copy not involving GPL'.
> 
> Note that some lawyers claim that at trade shows, you should not hand over
> a demo device running GPLed code to any interested party, as it would be
> distribution...

In the United States, 17 USC 109 specifically permits this:

"Notwithstanding the provisions of section 106 (3), the owner of a particular copy or phonorecord lawfully made under this title, or any person authorized by such owner, is entitled, without the authority of the copyright owner, to sell or otherwise dispose of the possession of that copy or phonorecord."

> IANAL, and I don't know abou the laws in other countries, but at least 
> in Germany modifications of a copyrighted work require the permission of 
> the copyright holder.

Ah, so coloring books are illegal in Germany? Or it's just illegal to color them in? Or you need a special license to do so?

> IANAL, but I have serious doubts whether putting some glue layer between 
> the GPL'ed code and the code with a not GPL compatible licence is really 
> a legally effictive way of circumventing the GPL.

The GPL has no power to control works that are neither GPL nor derived from GPL works. There is no need to circumvent situations the GPL has no business applying to.

This is a use of the GPL'd code. It's not a distribution and it's not a creative combination. It is, and should be, outside the GPL's scope.

> Read the paragraph starting with "These requirements apply to the 
> modified work as a whole." of the GPLv2.

There is no "modified work as a whole" in this case. A machine combination of two or more works produces those two or more works, not a work. Otherwise, the linker itself would be entitled to copyright on the new work, which is nonsense.

For copyright purposes, a work can only be created by creative effort. There is no creative effort in linking the kernel, ndiswrapper, and a Windows driver, so no "modified work as a whole" is created.

A linker cannot create a work because it is incapable of creative effort. If it cannot create a work, it cannot create a derivative work. There is no "modified work as a whole".

Section 2 of the GPL is about creative modifications that form a "work based on the Program". Only a human can do that. GPL section 2 actually makes that fairly clear:

"These requirements apply to the modified work as a whole.  If
identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to those
sections when you distribute them as separate works.  But when you
distribute the same sections as part of a whole which is a work based
on the Program, the distribution of the whole must be on the terms of
this License, whose permissions for other licensees extend to the
entire whole, and thus to each and every part regardless of who wrote it."

Note that it is only when you distribute the "same sections" as part of a "whole which is a work based on the Program". So these requirements only apply when someone creates a single work.

DS


