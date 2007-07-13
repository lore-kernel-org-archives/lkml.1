Return-Path: <linux-kernel-owner+w=401wt.eu-S1758259AbXGMLhy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758259AbXGMLhy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 07:37:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbXGMLhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 07:37:47 -0400
Received: from mail.atmel.fr ([81.80.104.162]:64535 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753817AbXGMLhq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 07:37:46 -0400
Message-ID: <46976387.3010509@rfo.atmel.com>
Date: Fri, 13 Jul 2007 13:35:35 +0200
From: Nicolas Ferre <nicolas.ferre@rfo.atmel.com>
Organization: atmel
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>, Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       =?ISO-8859-1?Q?Juha_Yrj=F6l=E4?= <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> \"Anderson F. Briglia\"" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>
Subject: Re: [RFC] Orphaning MMC host drivers
References: <4648BAC9.5020405@drzeus.cx>
In-Reply-To: <4648BAC9.5020405@drzeus.cx>
Content-Type: text/plain;
	charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: 7bit
X-ESAFE-STATUS: Mail clean
X-ESAFE-DETAILS: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman :
> +ATMEL AT91 MCI DRIVER
> +S:	Orphan
> +

Hi Pierre,

I come back on this request... better late than never ;-)

As I have patched the AT91 MCI driver these days, with the kind help of 
a few people, I think I can now add myself as maintainer for this 
driver. Here is the entry below.

Kind regards,
-- 
Nicolas Ferre

--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -662,7 +662,12 @@
  S:	Maintained

  ATMEL AT91 MCI DRIVER
-S:	Orphan
+P:	Nicolas Ferre
+M:	nicolas.ferre@rfo.atmel.com
+L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
+W:	http://www.atmel.com/products/AT91/
+W:	http://www.at91.com/
+S:	Maintained

  ATMEL MACB ETHERNET DRIVER
  P:	Haavard Skinnemoen


