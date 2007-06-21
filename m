Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXFUDrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXFUDrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 23:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753366AbXFUDrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 23:47:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbXFUDrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 23:47:13 -0400
To: david@lang.hm
Cc: Michael Poole <mdpoole@troilus.org>, Tomas Neme <lacrymology@gmail.com>,
       "Linux-Kernel\@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
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
	<87wsxysaad.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201232290.30395@asgard.lang.hm>
	<87odjas9f7.fsf@graviton.dyn.troilus.org>
	<Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm>
From: Alexandre Oliva <aoliva@redhat.com>
Organization: Red Hat OS Tools Group
Date: Thu, 21 Jun 2007 00:46:27 -0300
In-Reply-To: <Pine.LNX.4.64.0706201241060.30395@asgard.lang.hm> (david@lang.hm's message of "Wed\, 20 Jun 2007 12\:45\:24 -0700 \(PDT\)")
Message-ID: <ortzt2rmuk.fsf@oliva.athome.lsd.ic.unicamp.br>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.0.990 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 20, 2007, david@lang.hm wrote:

> but the signature isn't part of the kernel, and the code that checks
> the signature is completely independant.

Well, then remove or otherwise mangle the signature in the disk of
your TiVo DVR and see at what point the boot-up process halts.

-- 
Alexandre Oliva         http://www.lsd.ic.unicamp.br/~oliva/
FSF Latin America Board Member         http://www.fsfla.org/
Red Hat Compiler Engineer   aoliva@{redhat.com, gcc.gnu.org}
Free Software Evangelist  oliva@{lsd.ic.unicamp.br, gnu.org}
