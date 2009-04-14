Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbZDNQpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbZDNQpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 12:45:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755655AbZDNQos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 12:44:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55975 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755095AbZDNQor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 12:44:47 -0400
Date: Tue, 14 Apr 2009 18:44:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Pirko <jpirko@redhat.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com
Subject: Re: [PATCH] rculist.h: introduce list_entry_rcu and
	list_first_entry_rcu
Message-ID: <20090414164438.GA17839@elte.hu>
References: <20090414155327.GG6753@linux.vnet.ibm.com> <539490919.126011239727191996.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <539490919.126011239727191996.JavaMail.root@zmail02.collab.prod.int.phx2.redhat.com>
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


* Jiri Pirko <jpirko@redhat.com> wrote:

> ----- "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > There are a couple more places where this primitive could be applied.
> > I would welcome a patch for these as well.
> > 
> Ok I will do this once this patch hits the tree.

it has just hit the RCU tree so feel free :)

  http://people.redhat.com/mingo/tip.git/README

	Ingo
