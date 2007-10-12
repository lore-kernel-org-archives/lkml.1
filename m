Return-Path: <linux-kernel-owner+w=401wt.eu-S1758685AbXJLUGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685AbXJLUGP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 16:06:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755471AbXJLUGA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 16:06:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19874 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032AbXJLUF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 16:05:59 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Fri, 12 Oct 2007 16:05:38 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [GIT PULL] MMC updates
In-reply-to: <20071012215513.1a4dfc7d@poseidon.drzeus.cx>
Message-id: <alpine.LFD.0.9999.0710121603080.19446@xanadu.home>
References: <20071010212149.0073ee08@poseidon.drzeus.cx>
 <alpine.LFD.0.999.0710112228200.6887@woody.linux-foundation.org>
 <20071012215513.1a4dfc7d@poseidon.drzeus.cx>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007, Pierre Ossman wrote:

> On Thu, 11 Oct 2007 22:30:41 -0700 (PDT)
> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > 
> > There seems to be some breakage here:
> > 
> 
> Breakage repaired (and some new git voodoo learned. woot!). I even
> threw in a few randconfig for good measure. So repull and things should
> be peachy.

It is too late for a repull.  Linus' main branch already contains your 
previous incarnation, so you must publish a fix separately to go on top.


Nicolas
