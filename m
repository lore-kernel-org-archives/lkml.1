Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbXFTTUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbXFTTUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:20:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760342AbXFTTUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:20:13 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:49520
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760241AbXFTTUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:20:11 -0400
To: "Tomas Neme" <lacrymology@gmail.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
	<871wg6trnx.fsf@graviton.dyn.troilus.org>
	<2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 15:20:10 -0400
In-Reply-To: <2e6659dd0706201205i52e0b836oe642e2b442e425d7@mail.gmail.com> (Tomas Neme's message of "Wed\, 20 Jun 2007 16\:05\:46 -0300")
Message-ID: <87wsxysaad.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Neme writes:

>> It's simple: they don't provide _complete_ source code.  They keep the
>> source code for the part of their Linux kernel images that provides
>> the functionality "runs on Tivo DVRs".  The GPL requires that
>
> http://en.wikipedia.org/wiki/Tivoization does not agree that this is
> the problem but rather "TiVo circumvented this goal by making their
> products run programs only if the program's digital signature matches
> those authorised by the manufacturer of the TiVo."
>
> I'm downloading the sources now.. if they compile, then you're lying
> to me, right? Moreover, if I compile them as is, and I can run them on
> a TiVo (let's say upgrading the machine's kernel) then you're even
> more so..

Whether the sources you download from Tivo compile says very little.
It certainly does not mean I am wrong.  I could give you binary for
version A and sources for version B -- and the sources would compile.

The kernel you build from the source code that Tivo distributes must
be accepted by Tivo's hardware without making other modifications (to
Tivo's hardware or bootloader).  If that is possible, I will retract
what I said.  If it is not possible, they are omitting part of the
program's source code:

    A "computer program" is a set of statements or instructions to be
    used directly or indirectly in a computer in order to bring about
    a certain result.
    -- US Code, Title 17, Section 101

Michael Poole
