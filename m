Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab0BKCSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 21:18:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819Ab0BKCSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 21:18:40 -0500
Message-ID: <4B7368DF.60907@zytor.com>
Date: Wed, 10 Feb 2010 18:18:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
References: <20100209201309.902050211@sbs-t61.sc.intel.com>	<20100210011232.71CA51C5@magilla.sf.frob.com>	<20100210072756.GD31351@elte.hu> <20100210185815.4B4F9CC@magilla.sf.frob.com>
In-Reply-To: <20100210185815.4B4F9CC@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 10:58 AM, Roland McGrath wrote:
>> Yeah - and the patches your review strikes we'll remove/fix as well. And you 
>> can pick up the patches yourself as well into your tree, if you wish to. (or 
>> pull it from us if we are done) We can push it too with your acks - your 
>> call.
> 
> AFAIK there is no tree of mine that anyone habitually pulls from as part of
> a regular merge procedure.  Since the x86 patches have to go through your
> approval, and these ones are coming from someone else's postings (Suresh),
> I'm not sure how I would or should fit into the chain.  If you would like
> me to use a git branch for x86 things (ptrace things?  x86 ptrace things?)
> that have my ACK and I think should be merged, I'm glad to do that.
> 

We're happy to carry the patches as long as it's okay with you.  We were
mostly wondering if you preferred any other kind of workflow.

	-hpa
