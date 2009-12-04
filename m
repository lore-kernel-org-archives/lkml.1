Return-Path: <linux-kernel-owner+w=401wt.eu-S1754585AbZLDKsU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754585AbZLDKsU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 05:48:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbZLDKsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 05:48:20 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:35503 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405AbZLDKsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 05:48:19 -0500
Subject: Re: [PATCH UPDATED 7/7] sched: implement try_to_wake_up_local()
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: tglx@linutronix.de, mingo@elte.hu, avi@redhat.com, efault@gmx.de,
       rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
In-Reply-To: <4B1756F2.4070504@kernel.org>
References: <1259726212-30259-1-git-send-email-tj@kernel.org>
	 <1259726212-30259-8-git-send-email-tj@kernel.org>
	 <4B1756F2.4070504@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 11:47:53 +0100
Message-ID: <1259923673.3977.1948.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-03 at 15:13 +0900, Tejun Heo wrote:
> Updated tree available on top of current sched/core available in the
> following git trees.
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-core-for-ingo
>   git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git sched-wq-for-ingo

Would you have that in quilt format? git sucks for reviewing.

