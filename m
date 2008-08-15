Return-Path: <linux-kernel-owner+w=401wt.eu-S1759986AbYHOPDx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759986AbYHOPDx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 11:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755507AbYHOPDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 11:03:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52066 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbYHOPDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 11:03:42 -0400
Date: Fri, 15 Aug 2008 17:03:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, dipankar@in.ibm.com, bunk@kernel.org
Subject: Re: [PATCH] remove list_for_each_rcu()
Message-ID: <20080815150317.GD10029@elte.hu>
References: <20080801211105.GA14851@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801211105.GA14851@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello!
> 
> All of the in-tree uses of list_for_each_rcu() have been converted to
> list_for_each_entry_rcu(), so list_for_each_rcu() can now be removed.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

applied to tip/core/rcu - thanks.

	Ingo
