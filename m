Return-Path: <linux-kernel-owner+w=401wt.eu-S1761342AbXEOT3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761342AbXEOT3j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755792AbXEOT3c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:29:32 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51399 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755793AbXEOT3b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:29:31 -0400
X-Greylist: delayed 761 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 May 2007 15:29:31 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: [RFC] Orphaning MMC host drivers
Date: Tue, 15 May 2007 14:14:30 -0500
Message-ID: <9C23CDD79DA20A479D4615857B2E2C47E9FDD8@dlee13.ent.ti.com>
In-Reply-To: <4648BAC9.5020405@drzeus.cx>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC] Orphaning MMC host drivers
Thread-Index: AceWX5oeugQT/S5MSaeV4rO8SlOYLwAwtAYA
From: "Syed Mohammed, Khasim" <x0khasim@ti.com>
To: "Pierre Ossman" <drzeus-mmc@drzeus.cx>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Nicolas FERRE" <nicolas.ferre@rfo.atmel.com>,
       "Andrew Victor" <andrew@sanpeople.com>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Manuel Lauss" <mano@roarinelk.homelinux.net>,
       "Yoichi Yuasa" <yoichi_yuasa@tripeaks.co.jp>,
       "Pavel Pisa" <pisa@cmp.felk.cvut.cz>,
       "Sascha Hauer" <s.hauer@pengutronix.de>,
       "Russell King" <rmk+lkml@arm.linux.org.uk>,
       "Tony Lindgren" <tony@atomide.com>,
       "David Brownell" <david-b@pacbell.net>,
       =?iso-8859-1?B?SnVoYSBZcmr2bOQ=?= <juha.yrjola@solidboot.com>,
       "Briglia >> \"Anderson F. Briglia\"" <anderson.briglia@indt.org.br>,
       "Kyungmin Park" <kmpark@infradead.org>,
       "Carlos Aguiar" <carlos.aguiar@indt.org.br>
X-OriginalArrivalTime: 15 May 2007 19:14:31.0562 (UTC) FILETIME=[441C06A0:01C79725]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pierre,

Carlos Aguiar and Anderson Briglia are interested in making sure the driver works for existing boards as they have access to them, and I can make it work for new omaps (2430, 3430).

TI OMAP MMC INTERFACE DRIVER
P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
M:	linux-omap-open-source@linux.omap.com 
W:	http://linux.omap.com
W:	http://www.muru.com/linux/omap/
S:	Maintained

Regards,
Khasim
