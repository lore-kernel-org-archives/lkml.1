Return-Path: <linux-kernel-owner+w=401wt.eu-S1757035AbZEANUA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757035AbZEANUA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 09:20:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755802AbZEANTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 09:19:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37595 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755882AbZEANTs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 09:19:48 -0400
Date: Fri, 1 May 2009 14:16:40 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: =?ISO-8859-14?B?Um9n6XJpbw==?= Brito <rbrito@ime.usp.br>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Michael Tokarev <mjt@tls.msk.ru>,
       Mark Lord <lkml@rtr.ca>, linux-kernel@vger.kernel.org
Subject: Re: Quick question about libata and hdparm
Message-ID: <20090501141640.36eeecf1@lxorguk.ukuu.org.uk>
In-Reply-To: <20090501115048.GA2001@ime.usp.br>
References: <E693AEE4-7895-4650-A1DC-1FB16D409D5B@ime.usp.br>
	<200904211459.26965.bzolnier@gmail.com>
	<20090423055618.GA23042@ime.usp.br>
	<200904232331.13729.bzolnier@gmail.com>
	<6540c930904232000t76aa4954l4f5cee5bad64aacb@mail.gmail.com>
	<20090501091804.GB29466@ime.usp.br>
	<20090501113129.3f11d4f5@lxorguk.ukuu.org.uk>
	<20090501115048.GA2001@ime.usp.br>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-14
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 May 2009 08:50:48 -0300
Rogério Brito <rbrito@ime.usp.br> wrote:

> Hi, Alan.
> 
> On May 01 2009, Alan Cox wrote:
> > At the moment I've not found a way to duplicate your specific problem.
> 
> Would a remote access be useful in any way, Alan? I can give you access
> here without any problems.

Possibly yes when I have a bit of time to look at it. Especially if the
box can be set up so its booting off another device to the one that is a
problem and has the build tree for the kernel it is using on it so it can
be rebuilt with small tweaks to test stuff.

Alan
