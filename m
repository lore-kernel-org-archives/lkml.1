Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab0BJBXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:23:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:55212 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754876Ab0BJBXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:23:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,439,1262592000"; 
   d="scan'208";a="594577148"
Subject: Re: [patch v2 0/4] updated ptrace/core-dump patches for supporting
 xstate - V2
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Roland McGrath <roland@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "hjl.tools@gmail.com" <hjl.tools@gmail.com>
In-Reply-To: <20100210011232.71CA51C5@magilla.sf.frob.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	 <20100210011232.71CA51C5@magilla.sf.frob.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 09 Feb 2010 17:22:05 -0800
Message-Id: <1265764925.2833.15.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-09 at 17:12 -0800, Roland McGrath wrote:
> > Patches are on top of the -tip/master tree.
> > First patch in the series reverts the first version of the patch that went into
> > the -tip tree.
> 
> AFAIK tip/x86/ptrace is just a temporary branch containing nothing but your
> patch.  So I imagine you don't need a reversion, Ingo et al will just put
> the new patches on a fresh replacement branch.

That is my understanding too but was not sure. Wanted to mention that
they should either replace the branch or apply the reverted patch
(incase if they have issues with replacing the branch). Peter, you seem
to have applied the revert. Can you instead start with a fresh branch so
that we can just ignore the first version (and hence skip first revert
patch in this series)?

> I'll reply to each patch individually.

Thanks Roland.


