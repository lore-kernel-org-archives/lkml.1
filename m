Return-Path: <linux-kernel-owner+w=401wt.eu-S1752432AbZKDAlj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752432AbZKDAlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:41:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751712AbZKDAli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:41:38 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33839 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141AbZKDAlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:41:37 -0500
Date: Wed, 4 Nov 2009 00:40:15 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Luis Correia <luis.f.correia@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Ingo Molnar <mingo@elte.hu>, Johannes Berg <johannes@sipsolutions.net>,
       Jarek Poplawski <jarkao2@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       David Miller <davem@davemloft.net>
Subject: Re: [announce] new rt2800 drivers for Ralink wireless & project
 tree
Message-ID: <20091104004015.23c4c1a3@lxorguk.ukuu.org.uk>
In-Reply-To: <200911040052.28323.bzolnier@gmail.com>
References: <200911031951.05235.bzolnier@gmail.com>
	<200911032334.40547.bzolnier@gmail.com>
	<20091103234835.3042f7b5@lxorguk.ukuu.org.uk>
	<200911040052.28323.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Nov 2009 00:52:28 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Wednesday 04 November 2009 00:48:35 Alan Cox wrote:
> > > > Yeah I know that. But like I said, I still needed to get around to do that,
> > > > and I am very happy you were interested in fixing it.
> > > 
> > > Lets make one thing clear: YOU SHOULD BE THE ONE FIXING IT.
> > 
> > Really - you have a service and support contract with Ivo.. no i thought
> > not.
> 
> Just today I got PM from somebody complaining to me about non-working
> pata_pdc2026x_old (pdc202xx_old works fine for him) simply because
> I fixed some bug there some time ago....

And didn't bother committing a patch to both sets of code bec
