Return-Path: <linux-kernel-owner+w=401wt.eu-S1757757AbXK0Qrm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757757AbXK0Qrm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756120AbXK0Qrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:47:35 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42659 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755993AbXK0Qrf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:47:35 -0500
Date: Tue, 27 Nov 2007 17:47:23 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make I/O schedulers non-modular
Message-ID: <20071127164723.GA3406@stusta.de>
References: <20071125172237.GC6658@kernel.dk> <20071127070912.GB1735@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071127070912.GB1735@ff.dom.local>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2007 at 08:09:12AM +0100, Jarek Poplawski wrote:
> On 25-11-2007 18:22, Jens Axboe wrote:
> > On Sun, Nov 25 2007, Adrian Bunk wrote:
> ...
> >> Is there any technical reason why we need 4 different schedulers at all?
> > 
> > Until we have the perfect scheduler :-)
> 
> IMHO this is not enough yet. There is something called "the right
> of choice",

That's a common misconception about open source software:

There is nothing like a "right of choice".
There is a "right to change the source code".

This means you cannot demand from anyone to offer any choices, but you 
can fork the code yourself and use and distribute modified code 
containing any choices you consider reasonable.

> and, it seems, things are usually far from perfect
> where this right is not respected.

That's wrong.

It's actually often much worse to have different choices with different 
features and bugfixes than having one version that contains all features 
and all bugfixes.

> Regards,
> Jarek P.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

