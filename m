Return-Path: <linux-kernel-owner+w=401wt.eu-S934600AbXHGPKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934600AbXHGPKc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2007 11:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761005AbXHGPKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Aug 2007 11:10:25 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42639 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752831AbXHGPKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2007 11:10:24 -0400
Date: Tue, 7 Aug 2007 16:17:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Nathan Williams" <ngwilliams@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MODULE_LICENSE usage
Message-ID: <20070807161755.28e50234@the-village.bc.nu>
In-Reply-To: <b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
References: <b4e196fa0708060053x65f0b1d3m50c62206cb65e016@mail.gmail.com>
	<MDEHLPKNGKAHNMBLJOLKOEOJFOAC.davids@webmaster.com>
	<b4e196fa0708062029x681fafe7hc493c774a936cdf3@mail.gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> My company has been given documentation and the library source under
> the terms of an NDA with the chipset manufacturer.  We are permitted
> to compile the library and distribute the resultant binary blob, but
> not release the source to the library.
> 
> The binary blob is linked into the driver we have written.  We don't
> distribute this compiled module, customers are given the driver source
> and the library blob, which they compile themselves.

So you distribute a kernel derived work without following the GPL. I hope
you've discussed that with your legal team in depth.
