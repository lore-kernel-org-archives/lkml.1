Return-Path: <linux-kernel-owner+w=401wt.eu-S1946088AbXDEIPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946088AbXDEIPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946093AbXDEIPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:15:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946088AbXDEIPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:15:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       virtualization@lists.osdl.org, lkml <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>, Jan Beulich <JBeulich@novell.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch 1/2] Relocate VDSO ELF headers to match mapped location
 with COMPAT_VDSO
In-Reply-To: Jeremy Fitzhardinge's message of  Wednesday, 4 April 2007 23:46:29 -0700 <46149B45.2070502@goop.org>
X-Shopping-List: (1) Economical wavechord ghost-melts
   (2) Fluent thieving aluminum hatred
   (3) Curious robbers
   (4) Medical metronome effluents
Message-Id: <20070405081432.4CB82180055@magilla.sf.frob.com>
Date: Thu,  5 Apr 2007 01:14:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I did the second patch because I could, and to see if it would provoke
> some comment.  But effectively removing a kernel config option seems
> like a good idea to me.

Well, it provoked me to care whether the first patch the relocation
"really right".


Thanks,
Roland
