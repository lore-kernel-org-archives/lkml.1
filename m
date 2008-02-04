Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531AbYBDPbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531AbYBDPbA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYBDPas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:30:48 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41268 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756196AbYBDPar convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:30:47 -0500
Date: Mon, 4 Feb 2008 15:24:59 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: alejandro.riveira@gmail.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] sata_via.c: Remove missleading comment.
Message-ID: <20080204152459.2b40cc42@core>
In-Reply-To: <1202134792.5671.7.camel@Varda>
References: <1202134792.5671.7.camel@Varda>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Feb 2008 15:19:52 +0100
Alejandro Riveira Fernández <alejandro.riveira@gmail.com> wrote:

> Maybe for the trivial tree...
> 
> 
> sata_via.c has PATA support since:
> 
>   d73f30e1c9a9af14757fa5bf4014343926047156
>    
>   sata_via: PATA support
> 
> AFAICS so the TODO list is no longer true.

Yep well spotted
