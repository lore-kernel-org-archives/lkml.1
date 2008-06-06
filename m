Return-Path: <linux-kernel-owner+w=401wt.eu-S1756674AbYFFKgF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674AbYFFKgF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 06:36:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbYFFKfy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 06:35:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:48178 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753941AbYFFKfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 06:35:54 -0400
Date: Fri, 6 Jun 2008 11:09:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Vine <chris@cvine.freeserve.co.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: Re: pppd and 2.6.25 serial driver
Message-ID: <20080606110928.2e034c26@core>
In-Reply-To: <20080605222355.be299fff.akpm@linux-foundation.org>
References: <20080601215621.256db193@boulder.homenet>
	<20080605222355.be299fff.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The serial driver in 2.6.24.7 works correctly, and the good news is
> > that 2.6.26-rc2 also works fine.
> > 
> 
> Fun.  Presumably that means there's some serial fix which we forgot
> to backport.  Or it isn't in 2.6.25.x yet.

No relevant changes, and the 2.6.26 stuff isn't a trivial backport or
relevant either that I can see. Also it seems to work for everyone else
which makes me suspicious.

Alan
