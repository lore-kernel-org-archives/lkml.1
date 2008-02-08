Return-Path: <linux-kernel-owner+w=401wt.eu-S1763013AbYBHVnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763013AbYBHVnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 16:43:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762240AbYBHVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 16:43:15 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:51626 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760086AbYBHVnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 16:43:13 -0500
Date: Fri, 8 Feb 2008 21:36:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Daniel Hazelton <dhazelton@enter.net>
Cc: David Newall <davidn@davidnewall.com>,
       Marcel Holtmann <marcel@holtmann.org>, Greg KH <greg@kroah.com>,
       Christer Weinigel <christer@weinigel.se>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: mark USB drivers as being GPL only
Message-ID: <20080208213637.7abe50a0@core>
In-Reply-To: <200802081436.53928.dhazelton@enter.net>
References: <20080125180232.GA4613@kroah.com>
	<47ACA204.7030702@davidnewall.com>
	<47ACA8A5.9010807@davidnewall.com>
	<200802081436.53928.dhazelton@enter.net>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In other words "EXPORT_SYMBOL_GPL" isn't his idea of "a good legal idea", but 
> people ignoring this and doing things that circumvent this will, eventually, 
> have problems with the people who hold the copyright on the code. (In 
> addition, he stated that circumventing the "EXPORT_SYMBOL_GPL" bit might also 
> be in violation of the DMCA, but he isn't sure if a court would see it in the 
> same light as someone cracking the CSS key on a DVD expressly for the purpose 
> of creating pirated copies)

There was a good analysis of that argument on the list some time ago. I
think the conclusion was fairly definitively no as the GPL explicitly
gives the right to modify GPL code. You are therefore aready "authorised"
to make such a change.

It might have a significance in terms of intent but thats for lawyers to
argue over.

Alan
