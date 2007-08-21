Return-Path: <linux-kernel-owner+w=401wt.eu-S1756687AbXHUMWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbXHUMWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXHUMVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:21:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47900 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752197AbXHUMVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:21:45 -0400
Date: Tue, 21 Aug 2007 13:27:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sata_via: write errors on PATA drive connected to VT6421
Message-ID: <20070821132731.6bf10b50@the-village.bc.nu>
In-Reply-To: <200708202242.07290.linux@rainbow-software.org>
References: <200708202242.07290.linux@rainbow-software.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The transfer mode decreases from UDMA/100 to UDMA/66 and then UDMA/33 but it 
> doesn't help at all. The drive itself is fine, the problems also appear with 

Does it settle at UDMA33 or keep going down lower ?

