Return-Path: <linux-kernel-owner+w=401wt.eu-S1754819AbXDZN5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819AbXDZN5j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 09:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbXDZN5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 09:57:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49198 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbXDZN5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 09:57:37 -0400
Date: Thu, 26 Apr 2007 15:57:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: linux-kernel@vger.kernel.org
Cc: linux-rt-users@vger.kernel.org
Subject: v2.6.21-rt1
Message-ID: <20070426135730.GA2116@elte.hu>
References: <20070205065636.GA1652@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205065636.GA1652@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


i have released the v2.6.20-rt1 kernel, which can be downloaded from the 
usual place:

    http://redhat.com/~mingo/realtime-preempt/
 
more info about the -rt patchset can be found in the RT wiki:
 
    http://rt.wiki.kernel.org

This is a fixes-only release.

to build a 2.6.21-rt1 tree, the following patches should be applied:

  http://kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.tar.bz2
  http://redhat.com/~mingo/realtime-preempt/patch-2.6.21-rt1

	Ingo
