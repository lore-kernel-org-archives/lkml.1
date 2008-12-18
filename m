Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYLRWta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYLRWta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:49:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbYLRWtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:49:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47868 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751339AbYLRWtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:49:18 -0500
Date: Thu, 18 Dec 2008 22:49:05 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: mpm@selenic.com (Matt Mackall), davem@davemloft.net,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Stop scaring users with "treason uncloaked!"
Message-ID: <20081218224905.2bc81664@lxorguk.ukuu.org.uk>
In-Reply-To: <E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au>
References: <1229638581.3726.546.camel@calx>
	<E1LDRbc-0000Ro-1j@gondolin.me.apana.org.au>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Dec 2008 09:44:32 +1100
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Matt Mackall <mpm@selenic.com> wrote:
> > These debug messages are uninformative and extremely alarming. Rather
> > than reporting a peer as a treacherous attacker, report it more
> > correctly as simply broken. 
> 
> What's next, you're going to remove "printer on fire" as well?
> This message has been there for eons and is part of Linux lore.

It was changed. The printer on fire ? bit was adjusted to make it clear
because the original message *did* confuse and worry a few people.

IMHO Matt is right on this.

Alan
