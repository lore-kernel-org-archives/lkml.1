Return-Path: <linux-kernel-owner+w=401wt.eu-S1760087AbYHCWZD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760087AbYHCWZD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 18:25:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757363AbYHCWYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 18:24:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:53322 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757315AbYHCWYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 18:24:52 -0400
Date: Sun, 3 Aug 2008 23:07:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Bartlomiej Zolnierkiewicz" <bzolnier@gmail.com>
Cc: "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ide <linux-ide@vger.kernel.org>
Subject: Re: Kernel Summit request for Discussion of future of ATA (libata)
 and IDE
Message-ID: <20080803230738.3fb269c2@lxorguk.ukuu.org.uk>
In-Reply-To: <58cb370e0808031319o748e570bo700873365ba22aa1@mail.gmail.com>
References: <1217779055.4179.10.camel@localhost.localdomain>
	<20080803173941.314edf33@lxorguk.ukuu.org.uk>
	<1217783433.4179.18.camel@localhost.localdomain>
	<20080803194501.24fa3e51@lxorguk.ukuu.org.uk>
	<1217791284.4179.34.camel@localhost.localdomain>
	<20080803201719.576f85f6@lxorguk.ukuu.org.uk>
	<58cb370e0808031319o748e570bo700873365ba22aa1@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The contrary is also true, for modern drivers/ide conversion of libata PATA
> driver to use drivers/ide should usually be a matter of an hour or two.

Sounds about right for a typical device based upon the ones I did that
way.

