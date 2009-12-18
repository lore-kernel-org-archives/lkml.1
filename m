Return-Path: <linux-kernel-owner+w=401wt.eu-S932757AbZLRU4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932757AbZLRU4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 15:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932716AbZLRU4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 15:56:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932717AbZLRU4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 15:56:00 -0500
Date: Fri, 18 Dec 2009 12:54:56 -0800
From: Greg KH <gregkh@suse.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Fw: Re: [kernel] Re: kernel/rcutree.h:301: sorry,
 unimplemented: inlining failed in call to 'rcu_bootup_announce': function
 body not available
Message-ID: <20091218205456.GC6554@suse.de>
References: <20091218200839.GF6712@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218200839.GF6712@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:08:39PM -0800, Paul E. McKenney wrote:
> Hello, Greg,
> 
> Could you please consider the following commit for 2.6.32-stable?
> It fixes a build error that some people are seeing.
> 
> 							Thanx, Paul
> 
> dbe01350fa8ce0c11948ab7d6be71a4d901be151 rcu: Remove inline from forward-referenced functions

I'm guessing that you don't pay attention to the "now applied to the
staging..." emails that I send out when I apply patches to different
trees.  This patch is already queued up for the 2.6.32.2 release which
will happen in a few hours.

{sigh}

greg k-h
