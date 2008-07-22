Return-Path: <linux-kernel-owner+w=401wt.eu-S1756154AbYGVCXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154AbYGVCXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 22:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYGVCXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 22:23:08 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57491 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753928AbYGVCXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 22:23:07 -0400
Date: Tue, 22 Jul 2008 03:05:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, linux-next@vger.kernel.org
Subject: Re: Fix icom serial compile.
Message-ID: <20080722030519.7d0e5ee3@lxorguk.ukuu.org.uk>
In-Reply-To: <20080722112538.03c06649.sfr@canb.auug.org.au>
References: <20080721211659.GA29106@redhat.com>
	<20080721221355.GD3472@redhat.com>
	<20080721230742.4649b94a@lxorguk.ukuu.org.uk>
	<20080722112538.03c06649.sfr@canb.auug.org.au>
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

> > NAK. Already in the ttydev tree but not yet gone to Linus
> 
> I have just sent a similar patch.   I have to ask why you sent only some
> of these patches since they were known to break some builds and you had
> the fix patches already ...

I sent the first batch only because some later stuff didnt apply and I
happen to believe in testing patches before sending them (something I
note certain other people clearly do after shitting the lot at Linus)

I spent the past two days travelling, and all the net time I could get
trying to get the patches merged and tested. Everyone and their
grandmother keep patching the tty code again and again. I just had
another go before bed - its now six pulls in a row someone has broken the
patches.

Quite frankly if you want to moan about the fact I've been working till
4am trying to sort this mess out you can go see figure 1.
