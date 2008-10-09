Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbYJIC6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbYJIC6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 22:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754341AbYJIC6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 22:58:04 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:39731 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbYJIC6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 22:58:02 -0400
Date: Wed, 8 Oct 2008 19:57:56 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Noonan <steven@uplinklabs.net>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at kernel/sched_rt.c:322!
Message-ID: <20081009025756.GB7003@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20081009011456.GB10188@linux.vnet.ibm.com> <f488382f0810081945m4baea256odec9474869834a49@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f488382f0810081945m4baea256odec9474869834a49@mail.gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 07:45:38PM -0700, Steven Noonan wrote:
> On Wed, Oct 8, 2008 at 6:14 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > When I enable:
> >
> >        CONFIG_GROUP_SCHED=y
> >        CONFIG_FAIR_GROUP_SCHED=y
> >        CONFIG_USER_SCHED=y
> >
> > and run a bash script onlining and offlining CPUs in an infinite loop
> > on x86 using 2.6.27-rc9, after about 1.5 hours I get the following.
> 
> Is this a regression between 2.6.27-rc8 and -rc9, or did it crop up earlier?

Hello, Steve!

Good question.  I will run on older kernels.

							Thanx, Paul
