Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbXFTTsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbXFTTsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304AbXFTTsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:48:00 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:1505 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479AbXFTTr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:47:59 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Tomas Neme" <lacrymology@gmail.com>, <mdpool@troilus.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Date: Wed, 20 Jun 2007 12:47:55 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKMEBIEMAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3138
In-Reply-To: <871wg6trnx.fsf@graviton.dyn.troilus.org>
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 12:48:16 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Wed, 20 Jun 2007 12:48:17 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Tomas Neme writes:

> > I have been following this discussion for the last week or so, and
> > what I haven't been able to figure out is what the hell is the big
> > deal with TiVO doing whatever they want to with their stupid design.
> > They made a design, they build a machine, they sell it as is, and
> > provide source code for GPL'ed software... what's your problem?

> It's simple: they don't provide _complete_ source code.  They keep the
> source code for the part of their Linux kernel images that provides
> the functionality "runs on Tivo DVRs".  The GPL requires that
> distributors of binary versions provide complete source code, not just
> the parts of source code that are convenient.
>
> Michael Poole

That leads to lots of obvious nonsense unless you fix it with all kinds of
made up ad-hoc changes just to get the result you want. Why doesn't Linus
have to release the keys he uses to sign the Linux kernel source
distributions? That provides the functionality "can be proven to be
authorized by Linus". What you call "runs on Tivo DVRs", I call "can be
proven to be authorized by Tivo to run on Tivo DVRs".

The problem is that your description of the functionality as "runs on Tivo
DVRs" is an ad-hoc choice. You could describe that functionality any number
of other ways, and this is the only one that supports your argument. (Which
would be wrong anyway since functionality has nothing to do with whether
something is part of the source code or not. Copyright is not functional in
operation.)

Tivo's choice is an authorization decision. It is similar to you not having
root access to a Linux box. Sorry, you can't run a modified kernel on that
machine, but you can still modify the kernel and run it on any hardware
where authorization decisions don't stop you from doing so. The GPL was
never about such authorization decisions.

Suppose I make a machine that automatically accepts any kernel signed by
Linus and configures it, compiles it, and installs it. Does this change
Linus' signature into "works with my machine's kernel autoinstall"
functionality? The signature is proof Linus 'blessed' the release. Others
who trust Linus can use this functionally to make authorization decisions.
However, your releases are not blessed by Linus and there's no reason you
should be able to give them this 'blessed by Linus' functionality.

There are other legal reasons why this can't be right (most of them have
been stated at least three times in this thread), but I think the
commonsense argument is the most persuasive. Far from being part of the
source code, the signature is proof of source and authorization. These are
fact that don't apply to your modified release.

If I only want to run kernels signed by Linus, you have no right to trick me
into running a modified kernel. The Tivo only wants to run kernels signed by
Tivo.

Your argument is equivalent to saying that I have the right not just to run
modified Linux kernels on my own hardware but to compel others to run my
modifications even when authorization decisions say they won't run my
changes. (By bogusly calling authorization decisions 'functionality'.)

DS


