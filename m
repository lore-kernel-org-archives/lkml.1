Return-Path: <linux-kernel-owner+w=401wt.eu-S1753449AbYHPKtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753449AbYHPKtm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 06:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYHPKte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 06:49:34 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47378 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752142AbYHPKte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 06:49:34 -0400
Date: Sat, 16 Aug 2008 11:32:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ATA Kconfig cleanup: hide ATA_SFF and add SATA/PATA
 menu items
Message-ID: <20080816113224.5562a9a6@lxorguk.ukuu.org.uk>
In-Reply-To: <18598.42334.73411.476062@harpo.it.uu.se>
References: <qjoca411hv4hm25keq70ul5pnbi7747d13@4ax.com>
	<18598.42334.73411.476062@harpo.it.uu.se>
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

> I suspect sata_via will want this too.

Lust about any PATA chip may be on boards with SATA bridges so the divide
doesn't really work.
