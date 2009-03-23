Return-Path: <linux-kernel-owner+w=401wt.eu-S1757979AbZCWRzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979AbZCWRzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 13:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755678AbZCWRy6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 13:54:58 -0400
Received: from relay2.ptmail.sapo.pt ([212.55.154.22]:35383 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755673AbZCWRy5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 13:54:57 -0400
X-AntiVirus: PTMail-AV 0.3-0.92.0
Date: Mon, 23 Mar 2009 17:52:24 +0000
From: Luis Henriques <henrix@sapo.pt>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
Message-ID: <20090323175224.GA3938@hades.domain.com>
References: <20090318225137.GA3766@hades.domain.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318225137.GA3766@hades.domain.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
> Since they are used on in statistics and are always set to zero, the following
> fields from struct rq have been removed: yld_exp_empty, yld_act_empty and
> yld_both_empty.
> 
> Both Sched Debug and SCHEDSTAT_VERSION versions has also been incremented since
> ABIs have been changed.
> 

Hi Ingo,

Sorry to bother you but I can not find this patch in -tip.  Just would like to
confirm with you that it was NACK'ed or you just forgot to merge it to the tree.

Thanks,
-- 
Luis Henriques
