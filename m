Return-Path: <linux-kernel-owner+w=401wt.eu-S934308AbYD1Nih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934308AbYD1Nih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764816AbYD1Ni3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:38:29 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:56429 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932197AbYD1Ni3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:38:29 -0400
Date: Mon, 28 Apr 2008 16:37:56 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>, tglx@linutronix.de,
       hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: x86: fix a couple of sparse warnings
Message-ID: <20080428133756.GJ16379@cs181133002.pp.htv.fi>
References: <1209338159-30095-1-git-send-email-dmitri.vorobiev@gmail.com> <20080428123809.GD27997@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080428123809.GD27997@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 02:38:09PM +0200, Ingo Molnar wrote:
> 
> * Dmitri Vorobiev <dmitri.vorobiev@gmail.com> wrote:
> 
> > Hi Ingo, Peter, Thomas,
> > 
> > Here is a couple of patches that fix sparse warnings produced while 
> > compiling defconfig for i386:
> 
> thanks Dmitri, applied.

/me wonders what was wrong with http://lkml.org/lkml/2008/4/23/131
    that contains a superset of the first patch
    (and got no response at all)

> 	Ingo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

