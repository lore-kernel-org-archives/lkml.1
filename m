Return-Path: <linux-kernel-owner+w=401wt.eu-S938133AbXG0Wev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938133AbXG0Wev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 18:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762583AbXG0Wep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 18:34:45 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:60919 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764914AbXG0Weo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 18:34:44 -0400
Date: Fri, 27 Jul 2007 23:40:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Lamparter <lists@diac24.net>
Cc: Lionel Bouton <Lionel.Bouton@inet6.fr>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev
 to laptops
Message-ID: <20070727234026.3b40a170@the-village.bc.nu>
In-Reply-To: <20070727205242.GA1216@charon.n2.diac24.net>
References: <20070727205242.GA1216@charon.n2.diac24.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2007 22:52:43 +0200
David Lamparter <lists@diac24.net> wrote:

> [PATCH] ide: sis5513.c: Add FSC Amilo A1630 PCI subvendor/dev to laptops
> 
> Recognise the FSC Amilo A1630's incarnation of a SiS5513 chip as laptop to
> get UDMA100 support.
> 
> Signed-off-by: David Lamparter <equinox@diac24.net>

Looks good to me - I've made a matching update to drivers/ata/pata_sis.c
