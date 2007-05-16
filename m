Return-Path: <linux-kernel-owner+w=401wt.eu-S1760103AbXEPSFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103AbXEPSFH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPSE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:04:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758054AbXEPSEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:04:55 -0400
Date: Wed, 16 May 2007 20:04:47 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org
Subject: v2.6.21-rt2
Message-ID: <20070516180447.GA17922@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i'm pleased to announce the v2.6.20-rt2 kernel, which can be downloaded 
from the usual place:

    http://redhat.com/~mingo/realtime-preempt/
 
more info about the -rt patchset can be found in the RT wiki:
 
    http://rt.wiki.kernel.org

This is a fixes-mostly release and has been assembled by Thomas 
Gleixner. Thanks Thomas! Here are the various changes:

  - ppc fixes from Tsutomu OWA

  - new sh -rt port from Paul Mundt & Co

  - fixes for various problems by Steven Rostedt and Clark Williams

  - x86/64 high-res timers and dynticks update (Thomas Gleixner)

  - various fixes from Sergie Shtylyov

  - latency fixes from John Stultz

  - misc fixes

to build a 2.6.21-rt2 tree, the following patches should be applied:

  http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.21-rt2

	Ingo
