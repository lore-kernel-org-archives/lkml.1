Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbZDTV1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbZDTV1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 17:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZDTV1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 17:27:41 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:60332 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751212AbZDTV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 17:27:40 -0400
Date: Mon, 20 Apr 2009 22:19:55 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: =?ISO-8859-14?B?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>,
       Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090420221955.2c71bd26@lxorguk.ukuu.org.uk>
In-Reply-To: <200904202231.25670.bzolnier@gmail.com>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
	<49EB9758.3020506@garzik.org>
	<20090420173526.GA7935@ime.usp.br>
	<200904202231.25670.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> DISCLAIMER: I'm not handling this bugreport, this is best
> done by pata_pdc202xx_old Maintainer or libata Maintainer.

Be that as it may thanks - thats well spotted and definitely a bug.
