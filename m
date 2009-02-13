Return-Path: <linux-kernel-owner+w=401wt.eu-S1760837AbZBMPCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760837AbZBMPCA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 10:02:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758759AbZBMPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 10:01:51 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33103 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637AbZBMPBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:01:50 -0500
Message-Id: <20090213150055.947823726@goodmis.org>
User-Agent: quilt/0.46-1
Date: Fri, 13 Feb 2009 10:00:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>,
       Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 0/2] [git-pull] powerpc, ftrace clean ups 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Benjamin,

Please pull the latest ppc/ftrace tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
ppc/ftrace


Steven Rostedt (2):
      powerpc, ftrace: use unsigned int for instruction manipulation
      powerpc, ftrace: use create_branch lib function

----
 arch/powerpc/kernel/ftrace.c |   59 +++++++++++++----------------------------
 1 files changed, 19 insertions(+), 40 deletions(-)
-- 
