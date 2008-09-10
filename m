Return-Path: <linux-kernel-owner+w=401wt.eu-S1754473AbYIJPkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473AbYIJPkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 11:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYIJPkk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 11:40:40 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:35749 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbYIJPki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 11:40:38 -0400
Date: Wed, 10 Sep 2008 08:40:34 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Doc/RCU: fix pseudocode in rcuref.txt
Message-ID: <20080910154034.GF6742@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <48C73873.1010708@cn.fujitsu.com> <20080910063745.GC14700@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910063745.GC14700@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2008 at 08:37:45AM +0200, Ingo Molnar wrote:
> 
> * Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
> 
> > atomic_inc_not_zero(v) return 0 if *v = 0.
> > use spin_lock instead of write_lock for update lock.
> > 
> > Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> i've applied it to tip/core/rcu (unless Paul has objections) - thanks!

No objections here!!!

							Thanx, Paul
