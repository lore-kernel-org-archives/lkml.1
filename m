Return-Path: <linux-kernel-owner+w=401wt.eu-S935595AbZLPTYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935595AbZLPTYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 14:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935434AbZLPTYG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 14:24:06 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45861 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935559AbZLPTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 14:24:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EQwDB46IFa7Hu91GIHzJ41pXGZis1yuekEb1DLw1ElVf6/0NvHPEWJA7OUZRBZNQra
         zIsIlGb0fJEisuOY2LIQJbEMhhpdkpqZToyfDaBxhwCNGEuyJ4cqLz11zrtqd7mcXVXG
         VUrkdaEa+ULxLwsKafJ2CzKMRD6wkDNi3bZSo=
Date: Wed, 16 Dec 2009 20:23:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] sched: Teach might_sleep() about preemptible RCU
Message-ID: <20091216192354.GC5211@nowhere>
References: <20091216142536.GA18091@elte.hu> <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260991265-8451-1-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 16, 2009 at 08:21:05PM +0100, Frederic Weisbecker wrote:
> From: tip-bot for Frederic Weisbecker <fweisbec@gmail.com>


Crap... I think I'm really becoming this cyborg...

> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>


Although I've happily put Paul's Reviewed-by tag in this v2,
I'd feel more comfortable if he could confirm it :)

Thanks!

