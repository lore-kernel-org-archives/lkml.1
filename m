Return-Path: <linux-kernel-owner+w=401wt.eu-S933109AbZLRVzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109AbZLRVzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 16:55:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932956AbZLRVzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 16:55:18 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:47183 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932923AbZLRVzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 16:55:17 -0500
Date: Fri, 18 Dec 2009 13:55:16 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Greg KH <gregkh@suse.de>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: Fw: Re: [kernel] Re: kernel/rcutree.h:301: sorry,
	unimplemented: inlining failed in call to 'rcu_bootup_announce':
	function body not available
Message-ID: <20091218215516.GG6712@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091218200839.GF6712@linux.vnet.ibm.com> <20091218205456.GC6554@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091218205456.GC6554@suse.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 18, 2009 at 12:54:56PM -0800, Greg KH wrote:
> On Fri, Dec 18, 2009 at 12:08:39PM -0800, Paul E. McKenney wrote:
> > Hello, Greg,
> > 
> > Could you please consider the following commit for 2.6.32-stable?
> > It fixes a build error that some people are seeing.
> > 
> > 							Thanx, Paul
> > 
> > dbe01350fa8ce0c11948ab7d6be71a4d901be151 rcu: Remove inline from forward-referenced functions
> 
> I'm guessing that you don't pay attention to the "now applied to the
> staging..." emails that I send out when I apply patches to different
> trees.  This patch is already queued up for the 2.6.32.2 release which
> will happen in a few hours.
> 
> {sigh}

Color me oblivious, and apologies for the noise!

							Thanx, Paul
