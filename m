Return-Path: <linux-kernel-owner+w=401wt.eu-S932297AbYBNHs0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297AbYBNHs0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:48:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753743AbYBNHsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:48:17 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60185 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758536AbYBNHsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:48:17 -0500
Date: Thu, 14 Feb 2008 08:47:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, ananth@in.ibm.com,
       linux-kernel@vger.kernel.org, ak@suse.de, arjan@linux.intel.com
Subject: Re: [GIT PULL?] Create and populate toplevel tests/ for kernel
	tests
Message-ID: <20080214074748.GA30754@elte.hu>
References: <20080211104452.GB7944@in.ibm.com> <20080212164452.GA31096@infradead.org> <20080212132246.aac67ed1.akpm@linux-foundation.org> <20080212223918.GA3927@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080212223918.GA3927@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Sam Ravnborg <sam@ravnborg.org> wrote:

>  {kernel => tests}/backtracetest.c               |    0 
>  {drivers/misc => tests}/lkdtm.c                 |   12 ++--
>  {lib => tests}/locking-selftest-hardirq.h       |    0 
>  {lib => tests}/locking-selftest-mutex.h         |    0 
>  {lib => tests}/locking-selftest-rlock-hardirq.h |    0 
>  {lib => tests}/locking-selftest-rlock-softirq.h |    0 
>  {lib => tests}/locking-selftest-rlock.h         |    0 
>  {lib => tests}/locking-selftest-rsem.h          |    0 
>  {lib => tests}/locking-selftest-softirq.h       |    0 
>  {lib => tests}/locking-selftest-spin-hardirq.h  |    0 
>  {lib => tests}/locking-selftest-spin-softirq.h  |    0 
>  {lib => tests}/locking-selftest-spin.h          |    0 
>  {lib => tests}/locking-selftest-wlock-hardirq.h |    0 
>  {lib => tests}/locking-selftest-wlock-softirq.h |    0 
>  {lib => tests}/locking-selftest-wlock.h         |    0 
>  {lib => tests}/locking-selftest-wsem.h          |    0 
>  {lib => tests}/locking-selftest.c               |    0 
>  {kernel => tests}/rcutorture.c                  |    0 
>  {kernel => tests}/rtmutex-tester.c              |    2 +-
>  {kernel => tests}/test_kprobes.c                |    0 
>  27 files changed, 99 insertions(+), 82 deletions(-)

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
