Return-Path: <linux-kernel-owner+w=401wt.eu-S932236AbXHUS05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932236AbXHUS05 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 14:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761617AbXHUS0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 14:26:48 -0400
Received: from stout.engsoc.carleton.ca ([134.117.69.22]:38771 "EHLO
	stout.engsoc.carleton.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761458AbXHUS0r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 14:26:47 -0400
Date: Tue, 21 Aug 2007 14:14:20 -0400
From: Kyle McMartin <kyle@parisc-linux.org>
To: Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jarek Poplawski <jarkao2@o2.pl>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org
Subject: Re: RFC: drop support for gcc < 4.0
Message-ID: <20070821181420.GD22069@fattire.cabal.ca>
References: <20070821132038.GA22254@ff.dom.local> <20070821093103.3c097d4a.randy.dunlap@oracle.com> <20070821173550.GC30705@stusta.de> <20070821175453.GB19819@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070821175453.GB19819@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2007 at 06:54:53PM +0100, Russell King wrote:
> I want to keep support for gcc 3.4.3 for ARM for the forseeable future.
> From my point of view, gcc 4 compilers have been something of a development
> thing as far as the ARM architecture goes.  Also, gcc 3.4.3 is faster and
> significantly less noisy than gcc 4.
> 

+1, similar reasons, for parisc. Not that gcc4 doesn't work, but there's
some cases where gcc 3.4 still generates better code...

Regards,
	Kyle M.
