Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZCFO6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZCFO6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 09:58:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754168AbZCFO6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 09:58:01 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:38632 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753652AbZCFO6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 09:58:00 -0500
Date: Fri, 6 Mar 2009 09:57:58 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Walker <dwalker@fifo99.com>
cc: Randy Dunlap <randy.dunlap@oracle.com>, Yinghai Lu <yinghai@kernel.org>,
       <mingo@redhat.com>, <hpa@zytor.com>, <linux-kernel@vger.kernel.org>,
       <ebiederm@xmission.com>, <akpm@linux-foundation.org>, <gregkh@suse.de>,
       <tglx@linutronix.de>, <sarah.a.sharp@intel.com>, <mingo@elte.hu>,
       <linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/doc] x86/doc: mini-howto for using earlyprintk=dbgp
In-Reply-To: <1236296694.5937.107.camel@desktop>
Message-ID: <Pine.LNX.4.44L0.0903060955230.3461-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Mar 2009, Daniel Walker wrote:

> On Thu, 2009-03-05 at 15:41 -0800, Randy Dunlap wrote:
> 
> > If you have time to make a proposal for all such rules, please go ahead.
> > I don't have time for it just now.
> 
> I don't know what kind of rules there are .. The 80 columns thing was
> new to me.

In general, every rule in CodingStyle that _can_ apply to plain text 
documents _should_ apply.  There aren't very many that _can_ apply, 
however.  The 80-column rule may be the only one.

> > Yes, some examples, diagrams, samples, etc. are over 80 columns.
> > It's not a diehard rule.
> 
> With code it sort of is die hard , even tho the CodingStyle doesn't
> specify it that way.

It is _not_ diehard, at least not according to Linus.  He has posted a 
couple of messages expressing his opinion that overall readability is 
more important than sticking rigidly to 80 columns.

Alan Stern

