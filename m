Return-Path: <linux-kernel-owner+w=401wt.eu-S1763625AbXF0XyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763625AbXF0XyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 19:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763167AbXF0XyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 19:54:15 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2520 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763111AbXF0XyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 19:54:15 -0400
From: "David Schwartz" <davids@webmaster.com>
To: <linux-kernel@vger.kernel.org>
Subject: RE: how about mutual compatibility between Linux's GPLv2 and GPLv3?
Date: Wed, 27 Jun 2007 16:53:14 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKAELBEOAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <or3b0d0zdz.fsf@oliva.athome.lsd.ic.unicamp.br>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 16:53:12 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 27 Jun 2007 16:53:14 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Alexandre Oliva writes:

> Yes, but in the scenario I proposed, the source code *is* in the
> preferred form for making modifications, it just so happens to be
> behind a barrier you cannot trespass.  This is not different from
> shipping binaries and sources in a CD inside a locked box that you
> can't open.  You've received both, but how is the fact that you can't
> reach the source code (or the binaries) a violation of the GPL in this
> case?

Behind a barrier is not the preferred form for modification. Encrypted with
a key you don't have is not the preferred form for modification.

> And, if it's not a violation, what is it that makes the case of
> shipping programs in a locked enclosure different from shipping them
> in a locked computing device?

I honestly don't see what relevance this could possibly have. Getting access
to the source is a fundamental GPL right. The GPL is clear that you cannot
burden access to the source.

> When you modify a sculpture, you're modifying it in place, and this
> requires as much copyright permission as creating a modified copy of
> it.  Both count as modification.  And if TiVo creates artificial
> obstacles to your modifying the copy of GPLed programs that ships in
> its devices, then I believe it counts as a restriction on
> modification.

Of course your nonsense view leads to nonsense results. What a surprise. By
this argument, shipping a GPL'd work in ROM would violate the GPL because
you cannot easily modify that particular copy. Burning a GPL'd work to CDROM
would also be a violation. (See below for why your 'artificial' distinction
is wrong.)

> I ought to be entitled to modify any bit in the
> executable and expect that to have the same effect as modifying that
> bit on that executable on any other computer.

Nope, sorry. If this were true, you ought to be entitled to modify a bit in
the Linux kernel and have it have the same effect as modifying that Linux
kernel on my desktop. Again, nonsense view leads to nonsense conclusions.
The fix is to reject the nonsense view. There are no special GPL rights to
particular copies of works or particular hardware.

> The fact that it stops
> working as a result of TiVo's design to prohibit modification, rather
> than by any other differences in the computer (e.g., the absence of
> the signature checks), just goes to show that there is intent to
> impose further restrictions on modification of the software.

Intent is not the issue. The GPL does not care whether you intended to
comply or why you cannot comply, it just cares whether you do or don't
comply. If modifying software in this way is a GPL right, then anything that
prevents you from modifying software in this way is a GPL violation. If you
can't distribute so as to give all GPL rights, you can't distribute at all.

If the GPL says I can modify my distributed copy, then distributing on CDROM
is a GPL violation. It doesn't matter what your intent is. If you can't
distribute so as to honor all GPL rights, you can't distribute.

It is mind-bogglingly obvious that any sort of "right to modify one
particular copy" is *not* a GPL right.

> Saying that I can modify the sources and build another copy of the
> binary and then install that, but then it won't work, but that's fine
> because this is not modifying, while true, does not disqualify the
> claim that TiVo's design imposes artificial restrictions on my
> abilities to modify the copies of the program that I have received.

It doesn't matter. The GPL does not distinguish between artificial
restrictions and other restrictions. It doesn't permit *ANY* further
restrictions on GPL rights. If you can't grant all the rights (whether due
to artificial restrictions or other types of restrictions) you can't
distribute at all.

You are wasting an awful lot of time and effort analyzing things that have
*NO* GPL consequence at all.

DS


