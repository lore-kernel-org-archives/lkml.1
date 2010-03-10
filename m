Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0CJJxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 04:53:10 -0500
Received: from ozlabs.org ([203.10.76.45]:47769 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab0CJJxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 04:53:04 -0500
Date: Wed, 10 Mar 2010 20:52:59 +1100
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       linux-kernel@vger.kernel.org, anton@samba.org
Subject: [GIT PULL] Please pull my perf.git urgent branch
Message-ID: <20100310095259.GB3959@brick.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

My fix for the oops Anton was seeing was acked by Peter Z and
attracted no other comments, so please pull it and send it on to
Linus with the next batch of urgent fixes.

Thanks,
Paul.

The following changes since commit 548b84166917d6f5e2296123b85ad24aecd3801d:
  Ingo Molnar (1):
        Merge commit 'v2.6.34-rc1' into perf/urgent

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git urgent

Paul Mackerras (1):
      perf_event: Fix oops triggered by cpu offline/online

 kernel/perf_event.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)
