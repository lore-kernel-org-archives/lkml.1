Return-Path: <linux-kernel-owner+w=401wt.eu-S966584AbXIBNBF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966584AbXIBNBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 09:01:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965071AbXIBNAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 09:00:51 -0400
Received: from fresno.net.uniovi.es ([156.35.11.2]:56088 "EHLO
	FRESNO.NET.UNIOVI.ES" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965065AbXIBNAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 09:00:49 -0400
Date: Sun, 02 Sep 2007 15:00:46 +0200 (CEST)
From: Igor Sobrado <igor@condmat1.ciencias.uniovi.es>
Subject: Re: Fwd: That whole "Linux stealing our code" thing
In-reply-to: <20070902134612.28a88761@the-village.bc.nu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Adrian Bunk <bunk@kernel.org>,
       "Constantine A. Murenin" <mureninc@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Message-id: <Pine.LNX.4.64.0709021446550.6181@condmat1.ciencias.uniovi.es>
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
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2 Sep 2007, Alan Cox wrote:

>> So, a multi-licensed file remains multi-licensed except when all authors
>> agree about a change in the licensing terms.  And it is clear on the BSD
>
> Not strictly true. They can either agree to a change and issue one or
> they can convey to other parties the right to change the terms. The GPL
> for example does this for version selection.

So, under a dual-licensed BSD/GPL code the latter license allows a 
developer to remove the GPL license itself and release a single-licensed 
BSD code if other parties want to do it?

> A multi-licensed work (note work not file - don't assume a file is a
> boundary of a work) which conveys the choice of licence (as some bits of
> ath5k did) allows a receiving party to choose the licence it wishes.
> Failing that OpenBSD would have turned itself GPL by adding that file as
> according to your argument "it must be distributed under *all* these
> licensing terms concurrently".

I would assume a file as a boundary of a work in the case that file is 
under different licensing terms to the rest of the software package.  On a 
lot of software packages different modules are covered under different 
licensing terms.

We can choose what license terms we will honor; however, we do not have 
the ability to remove the licensing terms we do not like.

Igor.
