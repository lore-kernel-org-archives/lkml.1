Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbXEOJh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbXEOJh7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 05:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760398AbXEOJhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 05:37:52 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:38281 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760357AbXEOJhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 05:37:51 -0400
Message-ID: <46497F49.7070109@drzeus.cx>
Date: Tue, 15 May 2007 11:37:13 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Pavel Pisa <ppisa@pikron.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       "=?ISO-8859-2?Q?Juha_Yrj=F6l=E4?=" <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> \"Anderson F. Briglia\"" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>
Subject: Re: [RFC] Orphaning MMC host drivers
References: <4648BAC9.5020405@drzeus.cx> <200705150230.38617.ppisa@pikron.com>
In-Reply-To: <200705150230.38617.ppisa@pikron.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Pisa wrote:
> 
> as I have already stated, I would take responsibility
> for I.MX SDHC driver. It is not perfect, but I am trying
> to keep and fix it and I would be happy to receive
> feedback or help from others.
> 

Great.

> 
> Do you include change or should I send my own patch
> for review? Would you suggest change in driver name
> to MOTOROLA I.MX MMCI DRIVER ?
> 

I'll included it in my end.

As for the name, I think it's easier for people to find stuff if the vendor name
is included. I'll take your name (which is more detailed) and stick a MOTOROLA
in the front.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
