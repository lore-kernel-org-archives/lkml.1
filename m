Return-Path: <linux-kernel-owner+w=401wt.eu-S1757445AbXFTSTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757445AbXFTSTi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 14:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbXFTSTb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 14:19:31 -0400
Received: from 24-75-174-210-st.chvlva.adelphia.net ([24.75.174.210]:47233
	"EHLO sanosuke.troilus.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753053AbXFTSTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 14:19:31 -0400
To: "Tomas Neme" <lacrymology@gmail.com>
Cc: "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
References: <or645qfn99.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706171630150.14121@woody.linux-foundation.org>
	<orlkeidryp.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181104570.14121@woody.linux-foundation.org>
	<ork5u1awtq.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181232230.3593@woody.linux-foundation.org>
	<or7iq1atex.fsf@oliva.athome.lsd.ic.unicamp.br>
	<alpine.LFD.0.98.0706181344080.3593@woody.linux-foundation.org>
	<orhcp4algt.fsf@oliva.athome.lsd.ic.unicamp.br>
	<9a8748490706201034j43139301w5a18c172d688c724@mail.gmail.com>
	<2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com>
From: Michael Poole <mdpoole@troilus.org>
Date: Wed, 20 Jun 2007 14:19:30 -0400
In-Reply-To: <2e6659dd0706201110x20fa5c28n5d6fc094e9f5c832@mail.gmail.com> (Tomas Neme's message of "Wed\, 20 Jun 2007 15\:10\:37 -0300")
Message-ID: <871wg6trnx.fsf@graviton.dyn.troilus.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomas Neme writes:

> I have been following this discussion for the last week or so, and
> what I haven't been able to figure out is what the hell is the big
> deal with TiVO doing whatever they want to with their stupid design.
> They made a design, they build a machine, they sell it as is, and
> provide source code for GPL'ed software... what's your problem?

It's simple: they don't provide _complete_ source code.  They keep the
source code for the part of their Linux kernel images that provides
the functionality "runs on Tivo DVRs".  The GPL requires that
distributors of binary versions provide complete source code, not just
the parts of source code that are convenient.

Michael Poole
