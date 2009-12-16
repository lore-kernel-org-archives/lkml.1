Return-Path: <linux-kernel-owner+w=401wt.eu-S1759800AbZLPAxR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800AbZLPAxR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 19:53:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754376AbZLPAxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 19:53:15 -0500
Received: from relay3-v.mail.gandi.net ([217.70.178.77]:57431 "EHLO
	relay3-v.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZLPAxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 19:53:14 -0500
Date: Tue, 15 Dec 2009 16:53:01 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: Re: [PATCH RFC tip/core/rcu 12/18] rcu: make MAINTAINERS file
 match new RCU reality
Message-ID: <20091216005300.GB2408@feather>
References: <20091215230213.GA9093@linux.vnet.ibm.com>
 <12609181613187-git-send-email->
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12609181613187-git-send-email->
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 15, 2009 at 03:02:35PM -0800, Paul E. McKenney wrote:
> Proposed for 2.6.34, not for inclusion.
> 
> Both rcutorture and RCU are supported.  Also, update the files
> to match the new layout.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

At this point, I think it would make sense to just merge the rcutorture
entry into the main RCU entry; no real point keeping them separate.

- Josh Triplett
