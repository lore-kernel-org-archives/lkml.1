Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYGVLCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYGVLCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 07:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751277AbYGVLCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 07:02:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60958 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751189AbYGVLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 07:02:43 -0400
Date: Tue, 22 Jul 2008 11:44:36 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-ID: <20080722114436.2c13edea@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722130152.f115224d.sfr@canb.auug.org.au>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
	<20080722130152.f115224d.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What is your problem with the linux-next tree.  The problem was
> discovered and reported when I first merged the ttydev tree into
> linux-next on July 1.  The fixes were in linux-next on July 2.

Yes .. and ? The clashes kept happening despite that when I was doing the
merges (and going on holiday for a week and trying to sort it out with
limited time and internet access)

Sorry I don't follow your line of discussion at all here ?

> > just going to break the tree again and mean I have to run another set of
> > tests and regressions.
> 
> Please give what until tomorrow?

it - the situation. The patches have all gone to Linus.

Alan
