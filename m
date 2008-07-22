Return-Path: <linux-kernel-owner+w=401wt.eu-S1755896AbYGVCQy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755896AbYGVCQy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:16:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754524AbYGVCQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:16:46 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:46993 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754169AbYGVCQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:16:46 -0400
Date: Tue, 22 Jul 2008 02:58:50 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-ID: <20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
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

On Tue, 22 Jul 2008 10:25:20 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Linus, Alan,
> 
> Today's linux-next (actually just Linus' tree) build (powerpc
> ppc64_defconfig) failed like this:

Yes I know.

I've been trying to get the other patches merged but each of the five
pulls of Linus tree I have done has broken the tty patch merges *AGAIN*
so I still don't have them tested and ready to merge despite it being 3AM.

So much for the linux-next tree. Please give it until tomorrow or you are
just going to break the tree again and mean I have to run another set of
tests and regressions.

Alan
