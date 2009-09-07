Return-Path: <linux-kernel-owner+w=401wt.eu-S1753764AbZIGPYm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764AbZIGPYm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 11:24:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbZIGPYm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 11:24:42 -0400
Received: from smtp20.orange.fr ([80.12.242.26]:27754 "EHLO smtp20.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753632AbZIGPYl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 11:24:41 -0400
X-ME-UUID: 20090907152442706.AC74720000A1@mwinf2027.orange.fr
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
	measurements
From: Xavier Bestel <xavier.bestel@free.fr>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Markus Tornqvist <mjt@nysv.org>, Ingo Molnar <mingo@elte.hu>,
       Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de
In-Reply-To: <20090907074507.7f00a3ec@infradead.org>
References: <20090907121613.GA32097@elte.hu>
	 <20090907131905.GP28624@nysv.org>  <20090907074507.7f00a3ec@infradead.org>
Content-Type: text/plain
Date: Mon, 07 Sep 2009 17:24:29 +0200
Message-Id: <1252337069.31087.17.camel@skunk>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2009-09-07 at 07:45 -0700, Arjan van de Ven wrote:
> On Mon, 7 Sep 2009 16:41:51 +0300
> > >It shows similar curves and behavior to the 8-core results i posted 
> > >- BFS is slower than mainline in virtually every measurement. The 
> > >ratios are different for different parts of the graphs - but the 
> > >trend is similar.
> > 
> > Dude, not cool.
> > 
> > 1. Quad HT is not the same as a 4-core desktop, you're doing it with
> > 8 cores 
> 
> 4 cores, 8 threads. Which is basically the standard desktop cpu going
> forward... (4 cores already is today, 8 threads is that any day now)

Except on your typical smartphone, which will run linux and probably
vastly outnumber the number of "traditional" linux desktops.

	Xav



