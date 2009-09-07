Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZIGPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZIGPdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753505AbZIGPdv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:33:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:49752 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720AbZIGPdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:33:51 -0400
Date: Mon, 7 Sep 2009 08:37:10 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Xavier Bestel <xavier.bestel@free.fr>
Cc: Markus Tornqvist <mjt@nysv.org>, Ingo Molnar <mingo@elte.hu>,
       Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
 measurements
Message-ID: <20090907083710.3d78393c@infradead.org>
In-Reply-To: <1252337069.31087.17.camel@skunk>
References: <20090907121613.GA32097@elte.hu>
	<20090907131905.GP28624@nysv.org>
	<20090907074507.7f00a3ec@infradead.org>
	<1252337069.31087.17.camel@skunk>
Organization: Intel
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Sep 2009 17:24:29 +0200
Xavier Bestel <xavier.bestel@free.fr> wrote:

> 
> On Mon, 2009-09-07 at 07:45 -0700, Arjan van de Ven wrote:
> > On Mon, 7 Sep 2009 16:41:51 +0300
> > > >It shows similar curves and behavior to the 8-core results i
> > > >posted 
> > > >- BFS is slower than mainline in virtually every measurement.
> > > >The ratios are different for different parts of the graphs - but
> > > >the trend is similar.
> > > 
> > > Dude, not cool.
> > > 
> > > 1. Quad HT is not the same as a 4-core desktop, you're doing it
> > > with 8 cores 
> > 
> > 4 cores, 8 threads. Which is basically the standard desktop cpu
> > going forward... (4 cores already is today, 8 threads is that any
> > day now)
> 
> Except on your typical smartphone, which will run linux and probably
> vastly outnumber the number of "traditional" linux desktops.

yeah the trend in cellphones is only quad core without HT, not quad
core WITH ht ;-)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
