Return-Path: <linux-kernel-owner+w=401wt.eu-S1755691AbZIUJIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691AbZIUJIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 05:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755502AbZIUJIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 05:08:49 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:60806 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755463AbZIUJIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 05:08:49 -0400
Date: Mon, 21 Sep 2009 11:08:25 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [BUG] events process running on wrong cpu
Message-ID: <20090921090825.GE4649@osiris.boeblingen.de.ibm.com>
References: <20090921085155.GB4649@osiris.boeblingen.de.ibm.com>
 <1253523777.8439.155.camel@twins>
 <20090921090324.GA7701@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090921090324.GA7701@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 21, 2009 at 11:03:24AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> 
> > On Mon, 2009-09-21 at 10:51 +0200, Heiko Carstens wrote:
> > > Hi,
> > > 
> > > with todays git from time to time I get this (s390 defconfig):
> > 
> > Yep, I messed up..
> > 
> > Does your kernel contain the below?
> 
> FYI, that fix will go Linuswards later today.

Ok, so it's already fixed. Thanks! ;)
