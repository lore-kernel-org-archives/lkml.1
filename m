Return-Path: <linux-kernel-owner+w=401wt.eu-S932384AbXJSWuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932384AbXJSWuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 18:50:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757764AbXJSWuF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 18:50:05 -0400
Received: from www.tglx.de ([62.245.132.106]:38270 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758218AbXJSWuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 18:50:02 -0400
Date: Sat, 20 Oct 2007 00:49:43 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gabriel C <nix.or.die@googlemail.com>
cc: Jiri Kosina <jikos@jikos.cz>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Gabriel C <crazy@pimpmylinux.org>
Subject: Re: some kernel headers broken in current git ?
In-Reply-To: <47192E7D.7080409@googlemail.com>
Message-ID: <alpine.LFD.0.9999.0710200048290.22770@localhost.localdomain>
References: <4719174A.7020004@googlemail.com> <Pine.LNX.4.64.0710192307320.18815@twin.jikos.cz> <47191F6C.2040801@googlemail.com> <47192E7D.7080409@googlemail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Oct 2007, Gabriel C wrote:
> Gabriel C wrote:
> > Jiri Kosina wrote: 
> >> Trying 'make mrproper' first has high chances of fixing this I'd guess.
> > 
> > Is what I did before latest pull. 
> > 
> > Maybe this whole tree got broken. I'll try a fresh one and report back.
> > 
> 
> 
> I get the same on fresh cloned git tree
> 
> #-- git rev-parse --verify HEAD
> c4ec20717313daafba59225f812db89595952b83

Hmm. The kernel itself compiles fine ?

What external thing breaks ?

     tglx
