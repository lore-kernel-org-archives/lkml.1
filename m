Return-Path: <linux-kernel-owner+w=401wt.eu-S933796AbXIBP65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933796AbXIBP65 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 11:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbXIBP6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 11:58:46 -0400
Received: from fresno.net.uniovi.es ([156.35.11.2]:59094 "EHLO
	FRESNO.NET.UNIOVI.ES" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755716AbXIBP6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 11:58:44 -0400
Date: Sun, 02 Sep 2007 17:58:41 +0200 (CEST)
From: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
In-reply-to: <46DAC482.5090107@garzik.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Krzysztof Halasa <khc@pm.waw.pl>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Message-id: <Pine.LNX.4.64.0709021754250.6772@condmat1.ciencias.uniovi.es>
MIME-version: 1.0
Content-type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Content-transfer-encoding: 7BIT
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
 <f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
 <46D99FB7.6030505@garzik.org>
 <f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
 <20070901205457.GK9260@stusta.de> <20070902113638.78fbd202@the-village.bc.nu>
 <Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
 <20070902115041.GM16016@stusta.de>
 <Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
 <20070902134612.28a88761@the-village.bc.nu>
 <Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
 <m3642txj91.fsf@maximus.localdomain> <46DAC482.5090107@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Jeff Garzik wrote:

> Krzysztof Halasa wrote:
>>  WRT Atheros driver I'd probably leave the thing as is (i.e., BSD/GPL
>>  = in fact BSD), unless something like 50+% of the code is rewritten -
>>  it's mostly their hard work after all, isn't it? Not legal
>>  requirement, though.
>
> Yes.  This deserves to be reinforced:
>
> There is definite value in sharing the ath5k HAL between OpenBSD and Linux.

Of course.  Sharing knowledge and efforts can only improve both the GPL 
and BSD licensed code.  It is important in all cases, but becomes critical 
when support from manufacturers is limited or even non existent.  In these 
cases, shared efforts are required to write successful code.

Cheers,
Igor.
