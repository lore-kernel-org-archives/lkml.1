Return-Path: <linux-kernel-owner+w=401wt.eu-S1755593AbZG1Wn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755593AbZG1Wn3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 18:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbZG1Wn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 18:43:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57161 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754496AbZG1Wn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 18:43:27 -0400
Date: Tue, 28 Jul 2009 15:41:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ian Molton <ian@mnementh.co.uk>
Cc: pierre@ossman.eu, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, nico@cam.org,
       nicolas.ferre@rfo.atmel.com, hskinnemoen@atmel.com, tony@atomide.com,
       david-b@pacbell.net, manuel.lauss@gmail.com, mirq-linux@rere.qmqm.pl,
       ppisa@pikron.com, jarkko.lavinen@nokia.com, ben@fluff.org,
       saschasommer@freenet.de, avorontsov@ru.mvista.com, oakad@yahoo.com,
       HaraldWelte@viatech.com, JosephChan@via.com.tw, adrian.hunter@nokia.com
Subject: Re: New MMC maintainer needed
Message-Id: <20090728154137.36d68a4e.akpm@linux-foundation.org>
In-Reply-To: <4A6F6A40.60203@mnementh.co.uk>
References: <20090714153601.6dfe70ff@mjolnir.ossman.eu>
	<20090722151744.fffd7bf5.akpm@linux-foundation.org>
	<20090728222034.78966b3a@mjolnir.ossman.eu>
	<4A6F6A40.60203@mnementh.co.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jul 2009 22:14:40 +0100
Ian Molton <ian@mnementh.co.uk> wrote:

> Pierre Ossman wrote:
> 
> > MMC discussions tend to often be very system specific, which makes
> > lists such as the arm kernel list more appropriate. Also, I've always
> > tried to steer people to LKML as it allows others to keep a casual eye
> > on things.
> 
> I think an MMC list wouldnt be a bad idea now that we have a sort of 
> 'distributed maintainership' thing going on... itd help get people up to 
> speed...

I expect that Dave Miller can set up linux-mmc@vger.kernel.org in a
jiffy.  A MAINTAINERS patch should be made if this is done.

What I am unsure about is whether and how web-based archives of the vger
lists come into being - is it automatic, or should people be asked?

