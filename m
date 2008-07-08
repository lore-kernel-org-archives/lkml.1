Return-Path: <linux-kernel-owner+w=401wt.eu-S1756631AbYGHJLf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631AbYGHJLf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:11:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYGHJL0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:11:26 -0400
Received: from mtagate7.uk.ibm.com ([195.212.29.140]:42099 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbYGHJLZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:11:25 -0400
Date: Tue, 8 Jul 2008 11:10:58 +0200
From: Maxim Shchetynin <maxim@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
       linuxppc-dev@ozlabs.org
Cc: Uli Luckas <u.luckas@road.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: azfs: initial submit of azfs, a non-buffered filesystem
Message-ID: <20080708111058.6ca7e728@mercedes-benz.boeblingen.de.ibm.com>
In-Reply-To: <200807072137.45094.u.luckas@road.de>
References: <20080618160629.6cd749a8@mercedes-benz.boeblingen.de.ibm.com>
	<200807011659.33413.arnd@arndb.de>
	<20080707174230.63bc68cf@mercedes-benz.boeblingen.de.ibm.com>
	<200807072137.45094.u.luckas@road.de>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mon, 7 Jul 2008 21:37:43 +0200
schrieb Uli Luckas <u.luckas@road.de>:

> > AZFS is a file system which keeps all files on memory mapped random
> > access storage.
> Hi Maxim, 
> do you mean "memory backed" instead of "memory mapped"?

Right, I have corrected this already in my patch.
Thank you.

-- 
Mit freundlichen Grüßen / met vriendelijke groeten / avec regards

    Maxim V. Shchetynin
    Linux Kernel Entwicklung
    IBM Deutschland Entwicklung GmbH
    Linux für Cell, Abteilung 3250
    Schönaicher Straße 220
    71032 Böblingen

Vorsitzender des Aufsichtsrats: Johann Weihen
Geschäftsführung: Herbert Kircher
Sitz der Gesellschaft: Böblingen
Registriergericht: Amtsgericht Stuttgart, HRB 243294

Fahr nur so schnell wie dein Schutzengel fliegen kann!
