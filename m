Return-Path: <linux-kernel-owner+w=401wt.eu-S1760758AbYD2Of7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758AbYD2Of7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 10:35:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757596AbYD2Oft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 10:35:49 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59784 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753294AbYD2Ofs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 10:35:48 -0400
Date: Tue, 29 Apr 2008 16:35:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [(RESEND) PATCH] sched: fix RT task-wakeup logic
Message-ID: <20080429143527.GH26461@elte.hu>
References: <48103D18.BA47.005A.0@novell.com> <20080428162747.5784.82343.stgit@novell1.haskins.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428162747.5784.82343.stgit@novell1.haskins.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.3
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0346]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Gregory Haskins <ghaskins@novell.com> wrote:

> Hi Ingo,
>   Im not sure if this patch fell through the cracks, or if you didn't 
>   like it for some reason.  If you can, please ACK/NACK it so I know 
>   if you have reviewed it or not.  Thanks!

Your patch was in testing phase, and it is now in 
sched-devel.git/latest. 20 pull reuqests down the line sched-devel fell 
behind a bit ;-)

	Ingo
