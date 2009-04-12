Return-Path: <linux-kernel-owner+w=401wt.eu-S1752488AbZDLNHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488AbZDLNHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 09:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbZDLNHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 09:07:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42834 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZDLNHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 09:07:39 -0400
Date: Sun, 12 Apr 2009 15:07:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] blktrace: fix output of BLK_TC_PC events
Message-ID: <20090412130727.GC20281@elte.hu>
References: <49D3236D.3090705@cn.fujitsu.com> <49D32387.9040106@cn.fujitsu.com> <49E051B9.8060805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E051B9.8060805@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> Hi Ingo,
> 
> I would like to ask what's the status of these 2 patches.
> 
> Arnaldo acked on them.

They looked good to me - but i'm waiting for an Ack from Jens. Jens 
has complained about seeing un-ack-ed patches in the blktrace code, 
so i've started serializing any new patches on acks from Jens. The 
workflow would be more efficient i suspect if Jens 
nominated/declared you and Arnaldo as blktrace co-maintainers too - 
most of the patches come from you two.

	Ingo
