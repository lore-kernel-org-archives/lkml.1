Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbZIDM0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbZIDM0R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 08:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755744AbZIDM0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 08:26:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:44584 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755223AbZIDM0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 08:26:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WsigUZ8QWSoi+8sYzGjzEtkODJCXvtGtUrOm6IW
	xAsdMLYoafMiZj
Subject: Re: CPU scheduler weirdness?
From: Mike Galbraith <efault@gmx.de>
To: Marton Balint <cus@fazekas.hu>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Andreas Mohr <andi@lisas.de>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.0909040933540.7248@cinke.fazekas.hu>
References: <20090813084257.GA761@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908131720050.8321@cinke.fazekas.hu>
	 <20090813155812.GA15714@rhlx01.hs-esslingen.de>
	 <alpine.LNX.2.00.0908171758340.2764@cinke.fazekas.hu>
	 <1250665455.7583.326.camel@twins>
	 <alpine.LNX.2.00.0908191353100.19120@cinke.fazekas.hu>
	 <1250683834.7583.360.camel@twins>
	 <alpine.LNX.2.00.0908191428300.20409@cinke.fazekas.hu>
	 <1250707331.7154.1.camel@laptop>
	 <alpine.LNX.2.00.0908192125180.4364@cinke.fazekas.hu>
	 <20090820105645.GA23635@elte.hu>
	 <alpine.LNX.2.00.0908201814270.12548@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0908282240480.32738@cinke.fazekas.hu>
	 <alpine.LNX.2.00.0909032350580.20701@cinke.fazekas.hu>
	 <1252045561.7005.7.camel@marge.simson.net>
	 <alpine.LNX.2.00.0909040933540.7248@cinke.fazekas.hu>
Content-Type: text/plain
Date: Fri, 04 Sep 2009 14:26:14 +0200
Message-Id: <1252067174.8232.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-04 at 09:53 +0200, Marton Balint wrote:
> 
> On Fri, 4 Sep 2009, Mike Galbraith wrote:

> > Where does your schedtest.c and schedtest_mod.c live?
> 
> They were attached to one of my previous mails, i'm inlining them here to 
> make the discussion easier. Thanks for looking into this.

Thanks.  Ingo has already resolved it though.

	-Mike

