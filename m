Return-Path: <linux-kernel-owner+w=401wt.eu-S1760814AbXH2Vvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760814AbXH2Vvd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 17:51:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759754AbXH2VvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 17:51:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55549 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759568AbXH2VvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 17:51:10 -0400
Date: Wed, 29 Aug 2007 22:59:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: webmaster@dragonslave.de
Cc: dex@dragonslave.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Override 80-wire cable detection for Toshiba S1800-814
Message-ID: <20070829225921.6ffd5f98@the-village.bc.nu>
In-Reply-To: <200708292341.14212.dex@dragonslave.de>
References: <200708292341.14212.dex@dragonslave.de>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Aug 2007 23:41:13 +0200
Daniel Exner <dex@dragonslave.de> wrote:

> Hi!
> 
> Please CC me, as I'm currently not subscribed to this list, thx.
> 
> Attached patch will add above mentioned Laptop Model to whitelist for both 
> pata_ali and alim15x3, as it is correctly detected as 40-wire connected but 
> this cable is short enough to still do transfers higher than UDMA33.
> Don't know if this is also true for other S1800 Laptops cause I own only one.

Looks good to me - does need a Signed-off-by: line however
