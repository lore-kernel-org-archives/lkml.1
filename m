Return-Path: <linux-kernel-owner+w=401wt.eu-S1753559AbXJ3FdW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbXJ3FdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 01:33:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXJ3FdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 01:33:14 -0400
Received: from 1wt.eu ([62.212.114.60]:3602 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbXJ3FdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 01:33:14 -0400
Date: Tue, 30 Oct 2007 06:33:07 +0100
From: Willy Tarreau <w@1wt.eu>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Wijnand Rietman <wijnand.rietman@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_IDEDMA_AUTO & 2.4.32 & hdparm -d1
Message-ID: <20071030053307.GA1045@1wt.eu>
References: <b3790d380710290605g5d1770fao675418f062f111b9@mail.gmail.com> <20071029194241.GA27646@csclub.uwaterloo.ca> <b3790d380710291352k83e04ebl331f8bb784ba218c@mail.gmail.com> <20071029214551.GB27643@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029214551.GB27643@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2007 at 05:45:52PM -0400, Lennart Sorensen wrote:
> On Mon, Oct 29, 2007 at 09:52:35PM +0100, Wijnand Rietman wrote:
> > Thanks Lens for the suggestion!
> > 
> > Unfortunately this option doesn't work either. When I pass the "nodma"
> > paramater to the kernel, it boots with DMA disabled (like it should),
> > but doesn't allow DMA to be enabled anymore with hdparm.
> 
> Hmm, I was pretty sure I had the ability to turn it on after the fact
> before.  Perhaps I was wrong.  That would be silly.  There has to be
> some option to do what you want.

I too had to completely disable the config option with some CF which
caused long timeouts at boot time. I don't remember having been able
to re-enable anything afterwards (including other hard disks).

Willy

