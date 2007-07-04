Return-Path: <linux-kernel-owner+w=401wt.eu-S1761470AbXGDMFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761470AbXGDMFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:05:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757712AbXGDMEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:04:55 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:57011 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759529AbXGDMEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:04:55 -0400
Date: Wed, 4 Jul 2007 13:10:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Marc Dietrich <Marc.Dietrich@ap.physik.uni-giessen.de>
Cc: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Libata PATA status
Message-ID: <20070704131023.66a3cca7@the-village.bc.nu>
In-Reply-To: <200707041332.00769.marc.dietrich@ap.physik.uni-giessen.de>
References: <20070703185116.59c8f5f5@the-village.bc.nu>
	<1D2B5126-1238-48F8-B841-E8F77C9A0F1B@mac.com>
	<20070704102129.44945ea8@the-village.bc.nu>
	<200707041332.00769.marc.dietrich@ap.physik.uni-giessen.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm using pata-cmd64x for a few month now on my G3 powermac. So far no 
> problems except it only runs in UDMA/25 mode instead of UDMA/33 as the ide 
> driver does. And of course - no cdrom or zip because they are connected to 

That looks like a dumb bug actually. What chip variant do you have ?

