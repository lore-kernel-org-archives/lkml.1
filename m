Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab0BKESO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 23:18:14 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56867 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754182Ab0BKESN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 23:18:13 -0500
Message-ID: <4B738498.5080406@zytor.com>
Date: Wed, 10 Feb 2010 20:16:24 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Suresh Siddha <suresh.b.siddha@intel.com>,
       Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, hjl.tools@gmail.com
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
References: <20100209201309.902050211@sbs-t61.sc.intel.com>	<20100210011232.71CA51C5@magilla.sf.frob.com>	<20100210072756.GD31351@elte.hu>	<20100210185815.4B4F9CC@magilla.sf.frob.com>	<4B7368DF.60907@zytor.com> <20100211034553.A657CD14@magilla.sf.frob.com>
In-Reply-To: <20100211034553.A657CD14@magilla.sf.frob.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2010 07:45 PM, Roland McGrath wrote:
>> We're happy to carry the patches as long as it's okay with you.  We were
>> mostly wondering if you preferred any other kind of workflow.
> 
> When I write patches myself, I always use git, so it is always easy and
> most convenient for me to have my own branches pulled directly just to
> save on 'git rebase' churn later.
> 
> As to a regular workflow of using a well-known branch of mine, I think it
> makes sense for me to maintain a branch if there is an area where things
> are presumptively merged just on my approval and I'm the one who has to be
> lobbied to revert them.  I have not heretofore acquired the sensation that
> this was the case with any given area of code.

LOL, okay :)

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

