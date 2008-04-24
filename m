Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbYDXO65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbYDXO65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753278AbYDXO6t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:58:49 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42711 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753191AbYDXO6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:58:48 -0400
Date: Thu, 24 Apr 2008 15:27:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [2.6 patch] select ATA_SFF
Message-ID: <20080424152758.789e024c@the-village.bc.nu>
In-Reply-To: <481080EA.7010107@ru.mvista.com>
References: <20080421213147.GH2633@cs181133002.pp.htv.fi>
	<480DE3C4.5@ru.mvista.com>
	<480DE6F5.8060403@gmail.com>
	<480DE9E8.2070809@ru.mvista.com>
	<480DEB1F.5060500@gmail.com>
	<20080424123541.09e5ef96@the-village.bc.nu>
	<481080EA.7010107@ru.mvista.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     If you mean SFF-8038i (which can indeed be named "SFF/Intel"), it
> documents *only* BMDMA.  If you mean something else, please be more precise.

It documents where the PIO spaces are mapped, the class codes and then
documents the rest by inheriting it from the other specs. That makes it
the definitive spec for PCI "standard" controllers both PIO and DMA and
it is indeed followed literally by just about every PCI ATA controller
except the CS5520

Alan
