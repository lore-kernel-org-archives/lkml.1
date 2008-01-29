Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbYA2NB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbYA2NB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758686AbYA2NBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:01:07 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38870 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758651AbYA2NBF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:01:05 -0500
Date: Tue, 29 Jan 2008 07:00:59 -0600
From: Paul Jackson <pj@sgi.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: rmenage@google.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, mingo@elte.hu, dmitry.adamushko@gmail.com,
       ghaskins@novell.com, a.p.zijlstra@chello.nl
Subject: Re: [PATCH -v2 4/7] RT overloaded runqueues accounting
Message-Id: <20080129070059.0dd6c918.pj@sgi.com>
In-Reply-To: <20071023144615.89ed9c86.pj@sgi.com>
References: <20071023025900.927578809@goodmis.org>
	<20071023032916.651749224@goodmis.org>
	<20071022211709.7be79fea.pj@sgi.com>
	<6599ad830710222311x402c3d1agcc458742fb5e219c@mail.gmail.com>
	<Pine.LNX.4.58.0710230844040.29506@gandalf.stny.rr.com>
	<20071023144615.89ed9c86.pj@sgi.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Back in October 2007, this thread to which I am now (Jan 2008)
responding had a discussion of realtime versus normal load balancing
and how to setup sched domains for this, perhaps using cpusets.

Thanks to Peter Zijlstra, this discussion has started up again on lkml,
in the new thread:

   http://lkml.org/lkml/2008/1/29/60

Come on over and join the fun if you like.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
