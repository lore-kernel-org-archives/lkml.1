Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbXLDMwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbXLDMwR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752313AbXLDMwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:52:05 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39380 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752680AbXLDMwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:52:02 -0500
Date: Tue, 4 Dec 2007 12:45:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: tsbogend@alpha.franken.de (Thomas Bogendoerfer)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Andy Whitcroft <apw@shadowen.org>
Subject: Re: [PATCH] SC26XX: New serial driver for SC2681 uarts
Message-ID: <20071204124516.0120266a@the-village.bc.nu>
In-Reply-To: <20071204082534.GA5938@alpha.franken.de>
References: <20071202194346.36E3FDE4C4@solo.franken.de>
	<20071203155317.772231f9.akpm@linux-foundation.org>
	<20071203155746.2dc4506d@laptopd505.fenrus.org>
	<20071204082534.GA5938@alpha.franken.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Dec 2007 09:25:35 +0100
tsbogend@alpha.franken.de (Thomas Bogendoerfer) wrote:

> On Mon, Dec 03, 2007 at 03:57:46PM -0800, Arjan van de Ven wrote:
> > > > +#define SC26XX_MAJOR         204
> > > > +#define SC26XX_MINOR_START   205
> > > > +#define SC26XX_NR            2
> > 
> > did lanana assign these numbers officially?
> 
> I tried to numbers several months ago and didn't get any response 

Please raise it with the relevant people. If our LANANA administrator is
not doing their job then the Linuxfoundation need to find a replacement,
or hand control of it over to someone outside.

