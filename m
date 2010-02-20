Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab0BTAOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 19:14:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30771 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab0BTAOl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 19:14:41 -0500
Message-ID: <4B7F2959.4080301@redhat.com>
Date: Fri, 19 Feb 2010 22:14:17 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Borislav Petkov <borislav.petkov@amd.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent
 on PCI
References: <20100123113359.GA29555@one.firstfloor.org> <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org> <20100216204732.GA2301@elte.hu> <4B7B1C40.8070208@linux.intel.com> <alpine.LFD.2.00.1002191031190.2811@localhost.localdomain> <20100219121734.GA8300@basil.fritz.box> <20100219124540.GC30243@aftab> <4B7E906D.8050501@linux.intel.com> <4B7EAB9E.2010509@redhat.com> <4B7EB04E.8050601@linux.intel.com>
In-Reply-To: <4B7EB04E.8050601@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was thinking on a way where we could work with the EDAC/MCE issues, and
a way for us to move ahead. My proposal is to organize an EDAC/MCE BoF session
or a mini-summit during the Collaboration Summit, in San Francisco, with 
the interested parties. I suspect that some of us will be there already. 

It shouldn't be hard to find some place there for us to take a look at the
EDAC architecture and come with some proposal.

As today is the last day for CFP, I've also submitted there a proposal for a
panel. If approved, we can use it to collect data from hardware error users
(sysops and other users that require high availability on their services),
for us to discuss some strategies to address the issue or to summarize what
will be discussed on the event.

Comments?

Cheers,
Mauro
