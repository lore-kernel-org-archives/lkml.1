Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0BTJBL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 04:01:11 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566Ab0BTJBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 04:01:09 -0500
Date: Sat, 20 Feb 2010 10:01:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
	on PCI
Message-ID: <20100220090102.GA11287@basil.fritz.box>
References: <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain> <20100219121734.GA8300@basil.fritz.box> <20100219124540.GC30243@aftab> <4B7E906D.8050501@linux.intel.com> <4B7EAB9E.2010509@redhat.com> <4B7EB04E.8050601@linux.intel.com> <4B7F2959.4080301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7F2959.4080301@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 10:14:17PM -0200, Mauro Carvalho Chehab wrote:

Mauro,

> I was thinking on a way where we could work with the EDAC/MCE issues, and
> a way for us to move ahead. My proposal is to organize an EDAC/MCE BoF session
> or a mini-summit during the Collaboration Summit, in San Francisco, with 
> the interested parties. I suspect that some of us will be there already. 

I didn't plan to be there so far. A BoF is probably a good idea,
and also looking closely at EDAC together,
but it would be better at some more kernel focussed conference.

If everyone else is at that summit I can try to come,
but it would be likely difficult.

We could probably do some kind of online BoF shorter time
(e.g. using some chat setup or on the phone)


> It shouldn't be hard to find some place there for us to take a look at the
> EDAC architecture and come with some proposal.

Proposal for what exactly?

Is this for a event interface or for a topology interface or both
or something else entirely?

My personal plan so far was to work on the APEI interface
and then possibly look at migrating MCE to that infrastructure too,
while updating mcelog to talk to it. This would be mostly
addressing events so far.

> As today is the last day for CFP, I've also submitted there a proposal for a
> panel. If approved, we can use it to collect data from hardware error users
> (sysops and other users that require high availability on their services),
> for us to discuss some strategies to address the issue or to summarize what
> will be discussed on the event.

You want to collect error rates or want to collect use cases?

For a serious collection doing it online would probably
give better coverage.

I do both to some degree already.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
