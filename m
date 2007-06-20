Return-Path: <linux-kernel-owner+w=401wt.eu-S1761501AbXFTHf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761501AbXFTHf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 03:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758460AbXFTHft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 03:35:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757753AbXFTHfs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 03:35:48 -0400
To: "David Schwartz" <davids@webmaster.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <MDEHLPKNGKAHNMBLJOLKOENJELAC.davids@webmaster.com>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Wed, 20 Jun 2007 04:35:37 -0300
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOENJELAC.davids@webmaster.com> (David Schwartz's message of "Wed\, 20 Jun 2007 00\:07\:08 -0700")
Message-ID: <or645jw01i.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, "David Schwartz" <davids@webmaster.com> wrote:

> The freedom to "run the program, for any purpose" is just as much
> violated by Microsoft when they make the Xbox.

That's correct.

> You can't run the Linux kernel on that either, for the exact same
> reasons you can't run a modified Linux kernel on the Tivo.

Technically speaking, yes.

Legally speaking, these are completely different situations.

First of all, Microsoft is not in any way involved in how you received
the copy of the kernel Linux you'd like to run on the Xbox.  If it is,
you might have a claim that they couldn't impose this restriction on
you.  IANAL.

Second, you're not a user of Linux on the Xbox in the first place, so
you don't have an inherent right to run the program there that the
hardware manufacturer is denying you.  It's not much different than
wanting to run the program on on computers you have remote access to,
on which you have no permission to install Linux, or on computers you
have but with incompatible hardware architectures.

The case of incompatible hardware architectures is actually a bit
different, since nobody is really stopping you from running the
program there, it would just take you porting work to get to run it.

While in both the remote-access case and the Xbox case someone *is*
indeed stopping you from installing and running the software on those
computers, this does not render the software non-free, because you're
not a user of the software there in the first place, and stating that,
in order for software to be free, you'd have to have the ability to
install it on any existing computer in the world would be nonsensical.

However, in the case of TiVo, you have received the software from TiVo
with the express purpose of running it on the hardware they sold you,
and you can't install or run modified versions precisely because they
don't want to let you.  They're denying you a freedom that you are
entitled to have, which renders that binary copy of Linux installed on
it non-Free, and at the same time they're imposing further
restrictions on your freedoms that the GPL is designed to respect and
defend, which violates the spirit, if not the letter, of the GPL.

So you see, these are two very different cases, the key difference
being the obligation that TiVo accepted towards the copyright holders
of Linux, when it distributed the software to you, of respecting your
freedoms, by not imposing restrictions on your exercise of the
freedoms in addition the restrictions that the license itself imposes.

> (And GPL rights were always applicable equally to all hardware in
> the universe, not specially to some hardware and not others.)

Correct.  Whoever distributed you the software entitled you to enjoy
the freedoms wherever you manage to run the software.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
