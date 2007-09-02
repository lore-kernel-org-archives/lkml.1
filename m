Return-Path: <linux-kernel-owner+w=401wt.eu-S933936AbXIBOLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933936AbXIBOLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 10:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbXIBOLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 10:11:32 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:56771 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753181AbXIBOLb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 10:11:31 -0400
Message-ID: <46DAC482.5090107@garzik.org>
Date: Sun, 02 Sep 2007 10:11:14 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
References: <200709010140.l811eq9H005896@cvs.openbsd.org>	<f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>	<46D99FB7.6030505@garzik.org>	<f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>	<20070901205457.GK9260@stusta.de>	<20070902113638.78fbd202@the-village.bc.nu>	<Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>	<20070902115041.GM16016@stusta.de>	<Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>	<20070902134612.28a88761@the-village.bc.nu>	<Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es> <m3642txj91.fsf@maximus.localdomain>
In-Reply-To: <m3642txj91.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> WRT Atheros driver I'd probably leave the thing as is (i.e., BSD/GPL
> = in fact BSD), unless something like 50+% of the code is rewritten -
> it's mostly their hard work after all, isn't it? Not legal
> requirement, though.

Yes.  This deserves to be reinforced:

There is definite value in sharing the ath5k HAL between OpenBSD and Linux.

	Jeff


