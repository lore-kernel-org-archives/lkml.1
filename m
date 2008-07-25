Return-Path: <linux-kernel-owner+w=401wt.eu-S1753313AbYGYQKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313AbYGYQKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 12:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751317AbYGYQKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 12:10:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43442 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751307AbYGYQKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 12:10:13 -0400
Date: Fri, 25 Jul 2008 16:52:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Filipe Brandenburger <filipe.brandenburger@idilia.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Robert Hancock <hancockr@shaw.ca>,
       linux-kernel@vger.kernel.org
Subject: Re: Recommendation on an eSATA card well supported by Linux with
 built-in drivers and that supports hot plug
Message-ID: <20080725165255.43595c74@lxorguk.ukuu.org.uk>
In-Reply-To: <4889F28B.6000307@idilia.com>
References: <fa.jn2UBng193xTV9fhfIdhKpQQKRo@ifi.uio.no>
	<4888E188.4050708@shaw.ca>
	<488900E2.4000208@zytor.com>
	<4889F28B.6000307@idilia.com>
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

> Would you be also so kind as to recommend an actual eSATA card that uses
> the JMicron chip? Preferrably one that you have and use on a daily basis.

I've found the same in the UK - but there are alternatives although not
AHCI. The latest kernel supports the INIC SATA cards which lack some of
the goodies but do seem to be common on eSATA cards.
