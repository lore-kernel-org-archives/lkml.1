Return-Path: <linux-kernel-owner+w=401wt.eu-S1752496AbZKEKAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752496AbZKEKAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 05:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751092AbZKEKAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 05:00:40 -0500
Received: from mail.gmx.net ([213.165.64.20]:57627 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750848AbZKEKAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 05:00:39 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19jyXxDfIFjkfzufptlTyot6f4buctVLg6hcKQ0WY
	tjMqR/t0Ey9K3n
Subject: Re: [tip:sched/core] sched: Check for an idle shared cache in
 select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
       arjan@infradead.org, stable@kernel.org, tglx@linutronix.de
In-Reply-To: <1257415066.12867.1.camel@marge.simson.net>
References: <1256654138.17752.7.camel@marge.simson.net>
	 <tip-a1f84a3ab8e002159498814eaa7e48c33752b04b@git.kernel.org>
	 <20091105093016.GA18892@elte.hu>
	 <1257415066.12867.1.camel@marge.simson.net>
Content-Type: text/plain
Date: Thu, 05 Nov 2009 11:00:39 +0100
Message-Id: <1257415239.12867.3.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-05 at 10:57 +0100, Mike Galbraith wrote:

> Erk, indeed.  You didn't apply the follow-up fix, and I forgot as well.

But maybe you should just back it out until I've fiddled/tested a bit
more.  Dunno.

	-Mike

