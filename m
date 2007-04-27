Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbXD0Nuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbXD0Nuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 09:50:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbXD0Nuq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 09:50:46 -0400
Received: from rtr.ca ([64.26.128.89]:1473 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755846AbXD0Nun (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 09:50:43 -0400
Message-ID: <4631FFB1.90503@rtr.ca>
Date: Fri, 27 Apr 2007 09:50:41 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Marat Buharov <marat.buharov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
 FS is under heavy write load (massive starvation)
References: <1177660767.6567.41.camel@Homer.simpson.net>	 <20070427013350.d0d7ac38.akpm@linux-foundation.org>	 <698310e10704270459t7663d39dp977cf055b8db9d2a@mail.gmail.com> <1177677058.28223.11.camel@twins>
In-Reply-To: <1177677058.28223.11.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
>
> No way is globally disabling fsync() a good thing. I guess Andrew just
> is a sucker for punishment :-)

Mmm... perhaps another nice thing to include in laptop-mode operation?
