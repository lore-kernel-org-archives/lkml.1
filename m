Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbXLCOx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbXLCOx0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 09:53:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXLCOxT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 09:53:19 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:38850 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbXLCOxT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 09:53:19 -0500
Date: Mon, 3 Dec 2007 15:53:17 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Arjan van de Ven <arjan@infradead.org>, Chris Snook <csnook@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Avoid overflows in kernel/time.c
In-Reply-To: <474F8984.4010602@zytor.com>
Message-ID: <Pine.LNX.4.64.0711302017100.18767@fbirervta.pbzchgretzou.qr>
References: <200711300019.lAU0Jpbr003807@tazenda.hos.anvin.org>
 <474F6E7A.3090705@redhat.com> <474F7DC4.8000607@zytor.com>
 <20071129194027.10046988@laptopd505.fenrus.org> <474F8984.4010602@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 19:54, H. Peter Anvin wrote:
> Arjan van de Ven wrote:
>> >
>> > Anyway, I don't think compiling bc is hard on anything which has a C
>> > compiler.
>> 
>> alternative is to just also ship the precomputed values ;-)
>> 
>
> Oh, come on... it's not like bc is some obscure thing.  It's a POSIX utility.

People try building linux on not-so-posix systems these days...

