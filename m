Return-Path: <linux-kernel-owner+w=401wt.eu-S933703AbXIBN5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933703AbXIBN5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756445AbXIBN5f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:57:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:51740 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbXIBN5e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:57:34 -0400
To: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
References: <200709010140.l811eq9H005896@cvs.openbsd.org>
	<f34ca13c0709010948v67b04b58lb098713dc38c4d6a@mail.gmail.com>
	<46D99FB7.6030505@garzik.org>
	<f34ca13c0709011037p221cb40fjf69651d1858df212@mail.gmail.com>
	<20070901205457.GK9260@stusta.de>
	<20070902113638.78fbd202@the-village.bc.nu>
	<Pine.LNX.4.64.0709021303001.4312@condmat1.ciencias.uniovi.es>
	<20070902115041.GM16016@stusta.de>
	<Pine.LNX.4.64.0709021416130.6181@condmat1.ciencias.uniovi.es>
	<20070902134612.28a88761@the-village.bc.nu>
	<Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sun, 02 Sep 2007 15:57:30 +0200
In-Reply-To: <Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es> (Igor Sobrado's message of "Sun, 02 Sep 2007 15:00:46 +0200 (CEST)")
Message-ID: <m3642txj91.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

IANAL, but:

Igor Sobrado <igor@condmat1.ciencias.uniovi.es> writes:

> So, under a dual-licensed BSD/GPL code the latter license allows a
> developer to remove the GPL license itself and release a
> single-licensed BSD code if other parties want to do it?

Of course. If it wasn't legal, dual BSD/GPL would just be equal
to GPL. Now, dual BSD/GPL equals BSD.

OTOH I'd probable leave the original licence text, something like:

The actual licence conditions:
GPL or BSD or whatever.

Portions of this file were licenced under:
[the original licence text, not valid as a licence for current file]


WRT Atheros driver I'd probably leave the thing as is (i.e., BSD/GPL
= in fact BSD), unless something like 50+% of the code is rewritten -
it's mostly their hard work after all, isn't it? Not legal
requirement, though.
-- 
Krzysztof Halasa
