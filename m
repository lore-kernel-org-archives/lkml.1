Return-Path: <linux-kernel-owner+w=401wt.eu-S1753428AbZGVUrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428AbZGVUrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 16:47:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752801AbZGVUrb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 16:47:31 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:32871 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbZGVUrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 16:47:31 -0400
Subject: Re: [PATCH 1/6] regulator: Add regulator_get_exclusive() API
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Eric Miao <eric.y.miao@gmail.com>, Daniel Ribeiro <drwyrm@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Brownell <david-b@pacbell.net>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Haojian Zhuang <haojian.zhuang@gmail.com>
In-Reply-To: <20090722095803.GB21171@rakim.wolfsonmicro.main>
References: <1248188428-11277-1-git-send-email-broonie@opensource.wolfsonmicro.com>
	 <1248209397.4333.50.camel@brutus> <4A667231.3020809@gmail.com>
	 <20090722095803.GB21171@rakim.wolfsonmicro.main>
Content-Type: text/plain
Date: Wed, 22 Jul 2009 21:47:29 +0100
Message-Id: <1248295649.25964.848.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 10:58 +0100, Mark Brown wrote:
> On Wed, Jul 22, 2009 at 09:58:09AM +0800, Eric Miao wrote:
> > Daniel Ribeiro wrote:
> 
> > > Can you update pxamci.c and twl4030-mmc.c to make use of this new API?
> 
> > I think that deserves another two patches for making use of this
> > new API.
> 
> Due to my workload, the cross tree merge issues and my lack of any test
> hardware I wasn't in a hurry to do that myself - probably not until
> after the merge window.  It'd probably be as easy for people with
> relevant systems to do the updates.

I agree, my workload wont allow me to test this on my pxa atm :-/

Eric, Daniel, any chance you could oblige with a tested patch for your
respective systems ?

Thanks

Liam

