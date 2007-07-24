Return-Path: <linux-kernel-owner+w=401wt.eu-S933654AbXGXMMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654AbXGXMMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 08:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758051AbXGXMMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 08:12:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51676 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756624AbXGXMMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 08:12:34 -0400
Date: Tue, 24 Jul 2007 14:12:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: v2.6.23-rc1-rt0
Message-ID: <20070724121227.GA18670@elte.hu>
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


[ repost with the correct subject line ]

i've released the v2.6.23-rc1-rt0 kernel, which can be downloaded from 
the usual place:
 
   http://redhat.com/~mingo/realtime-preempt/
 
as the rt0 name suggests it, this is a devel release, the first one 
after a rebase to 2.6.23-rc1. There's lots of changes and a reduction of 
50 patches (we are now at 320 patches) - so code from -rt is moving 
upstream at a steady pace. (latest bigger chunks that moved were CFS, 
lockstat, most of the -hrt queue, plus various fixes)
    
more info about the -rt patchset can be found in the RT wiki:
     
  http://rt.wiki.kernel.org
  
to build a 2.6.22.1-rt5 tree, the following patches should be applied:
 
  http://kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.23-rc1.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.23-rc1-rt0
  
	Ingo
