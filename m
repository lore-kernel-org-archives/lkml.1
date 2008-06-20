Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYFTS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYFTS22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYFTS2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 14:28:14 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57946 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751398AbYFTS2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 14:28:13 -0400
Date: Fri, 20 Jun 2008 19:09:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [git patches] IDE fixes
Message-ID: <20080620190948.537f7f7a@lxorguk.ukuu.org.uk>
In-Reply-To: <200806202007.38081.bzolnier@gmail.com>
References: <200806202007.38081.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.8; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> +	PCMCIA_DEVICE_PROD_ID12("TRANSCEND", "TS1GCF45", 0x709b1bf1, 0xf68b632),

That one seems to be a digit short - is it 0x0f68b632 or a typo ?


Alan
