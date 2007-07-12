Return-Path: <linux-kernel-owner+w=401wt.eu-S1765468AbXGLMOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765468AbXGLMOU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 08:14:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761421AbXGLMOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 08:14:04 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:40027 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763554AbXGLMOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 08:14:01 -0400
Date: Thu, 12 Jul 2007 14:13:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: v2.6.22.1-rt1
Message-ID: <20070712121355.GA10949@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


we are pleased to announce the v2.6.22.1-rt1 kernel, which can be 
downloaded from the usual place:
 
   http://redhat.com/~mingo/realtime-preempt/
  
more info about the -rt patchset can be found in the RT wiki:
  
   http://rt.wiki.kernel.org
 
This release is a port of -rt to the latest upstream kernel. Thomas' 
latest -hrt queue is included and also the latest CFS changes. The SMP 
balancing fix from Sebastien Dugue is included as well.

to build a 2.6.22.1-rt1 tree, the following patches should be applied:
 
   http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.22.1.tar.bz2
   http://redhat.com/~mingo/realtime-preempt/patch-2.6.22.1-rt1
 
	Ingo
