Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZDLNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZDLNKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751981AbZDLNKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:10:30 -0400
Received: from brick.kernel.dk ([93.163.65.50]:33882 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZDLNKa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:10:30 -0400
Date: Sun, 12 Apr 2009 15:10:28 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
Message-ID: <20090412131028.GT5178@kernel.dk>
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com> <49E051B9.8060805@cn.fujitsu.com> <20090412130727.GC20281@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412130727.GC20281@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12 2009, Ingo Molnar wrote:
> 
> * Li Zefan <lizf@cn.fujitsu.com> wrote:
> 
> > Hi Ingo,
> > 
> > I would like to ask what's the status of these 2 patches.
> > 
> > Arnaldo acked on them.
> 
> They looked good to me - but i'm waiting for an Ack from Jens. Jens 
> has complained about seeing un-ack-ed patches in the blktrace code, 
> so i've started serializing any new patches on acks from Jens. The 
> workflow would be more efficient i suspect if Jens 
> nominated/declared you and Arnaldo as blktrace co-maintainers too - 
> most of the patches come from you two.

I'd be fine with listing Li Zefan as co-maintainer of the blktrace bits.
He knows what he is doing and is also a user of blktrace, so I think he
would be fine. Li, what do you think?

-- 
Jens Axboe

