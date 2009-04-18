Return-Path: <linux-kernel-owner+w=401wt.eu-S1756031AbZDRHbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbZDRHbp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 03:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbZDRHbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 03:31:37 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56031 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbZDRHbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 03:31:36 -0400
Date: Sat, 18 Apr 2009 09:30:19 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>
Subject: Re: [PATCH] doc: fix kernel-parameters.txt mistaken deletions
Message-ID: <20090418073019.GH7678@elte.hu>
References: <20090417183028.83a1dc04.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417183028.83a1dc04.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Re-add missing kernel-parameters documentation that was accidentally
> deleted in commit 0cb55ad2.
> 
> Thanks to Ingo and Weidong Han for the heads-up on this.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Ingo Molnar <mingo@elte.hu>
> cc: Len Brown <lenb@kernel.org>

Thanks Randy. I've cherry-picked this commit:

  66a2f36: docs, x86: add nox2apic back to kernel-parameters.txt

over into the tip:x86/urgent branch to make the upstream fix 
complete.

	Ingo
