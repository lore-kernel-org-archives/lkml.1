Return-Path: <linux-kernel-owner+w=401wt.eu-S1751380AbXBVCkp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380AbXBVCkp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 21:40:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbXBVCko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 21:40:44 -0500
Received: from ns1.suse.de ([195.135.220.2]:38013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbXBVCkn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 21:40:43 -0500
From: Neil Brown <neilb@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 22 Feb 2007 13:39:56 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17885.636.133245.572876@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 006 of 6] md: Add support for reshape of a raid6
In-Reply-To: message from Andrew Morton on Wednesday February 21
References: <20070220172544.15678.patches@notabene>
	<1070220063516.16208@suse.de>
	<20070221144806.e6eed85c.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday February 21, akpm@linux-foundation.org wrote:
> On Tue, 20 Feb 2007 17:35:16 +1100
> NeilBrown <neilb@suse.de> wrote:
> 
> > +		for (i = conf->raid_disks ; i-- ;  ) {
> 
> That statement should be dragged out, shot, stomped on then ceremonially
> incinerated.

An experiment in lateral thinking?  I liked it, but there is no
accounting for taste.

> 
> What's wrong with doing
> 
> 	for (i = 0; i < conf->raid_disks; i++) {
> 
> in a manner which can be understood without alcoholic fortification?

I guess...  "Egoless programmer" and all that, "write for others to
read, not for the compiler", and as you say it comes to the same
number of bytes of code on common architectures.

> 
> ho hum.


I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.
I must right code that Andrew can read.


NeilBrown
