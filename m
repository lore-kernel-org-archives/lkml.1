Return-Path: <linux-kernel-owner+w=401wt.eu-S1761070AbXHCHlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761070AbXHCHlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752283AbXHCHlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:41:39 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:43508 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbXHCHlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:41:39 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
In-reply-to: <1186125327.12034.121.camel@twins> (message from Peter Zijlstra
	on Fri, 03 Aug 2007 09:15:27 +0200)
Subject: Re: per bdi dirty balancing (was Re: kupdate weirdness)
References: <E1IGL4G-00088R-00@dorka.pomaz.szeredi.hu>
	 <20070801141439.ff1c29f9.akpm@linux-foundation.org>
	 <E1IGcyd-00025s-00@dorka.pomaz.szeredi.hu>
	 <20070802121806.d7071ba1.akpm@linux-foundation.org>
	 <E1IGgS3-0002ib-00@dorka.pomaz.szeredi.hu>
	 <1186091062.11797.34.camel@lappy>
	 <E1IGqsn-0003uq-00@dorka.pomaz.szeredi.hu> <1186125327.12034.121.camel@twins>
Message-Id: <E1IGrmY-000416-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 03 Aug 2007 09:41:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > My plan is to extract the minimal set of features from your patchset,
> > that solves the dirty balancing deadlocks and submit them as quickly
> > as possible.
> 
> I had hoped to post a new version yesterday, but lets hope for today.

Would be cool.

> > After that we can look at trying to solve the more ambitious problem
> > of the slow vs. fast devices in a way that not only you can understand ;)
> 
> Drad, and here I thought all that documentation in the proportions lib
> would have solved that :-(

Well, I didn't get that far, and only had a glimpse of the proportions
lib.  But my hunch is that there's still lots of room for simplification.

Miklos
