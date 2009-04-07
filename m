Return-Path: <linux-kernel-owner+w=401wt.eu-S1756678AbZDGPlS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678AbZDGPlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:41:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZDGPlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:41:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40590 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753576AbZDGPlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:41:04 -0400
Date: Tue, 7 Apr 2009 08:38:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jens Axboe <jens.axboe@oracle.com>
cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org,
       gentuu@gmail.com
Subject: Re: [GIT PULL] block updates for 2.6.30-rc1
In-Reply-To: <20090407114923.GT5178@kernel.dk>
Message-ID: <alpine.LFD.2.00.0904070837420.27889@localhost.localdomain>
References: <20090407113909.GS5178@kernel.dk> <a4423d670904070444p75bb8811p779ca9ed12719df4@mail.gmail.com> <20090407114923.GT5178@kernel.dk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 7 Apr 2009, Jens Axboe wrote:
> > I sent you a fix for loop device.
> > http://patchwork.kernel.org/patch/15763/
> 
> I missed that the thread had the loop fix as well. I've included it now,
> looks fine to me. Linus, the new diffstat is now:

No, I still see the old diffstat. Did you forget to push out?

		Linus
