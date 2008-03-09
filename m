Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbYCIRMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbYCIRMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 13:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbYCIRJ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 13:09:28 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:41109 "EHLO
	viefep16-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753414AbYCIRJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 13:09:27 -0400
X-SourceIP: 80.56.237.116
Message-Id: <20080309170850.256853000@chello.nl>
User-Agent: quilt/0.45-1
Date: Sun, 09 Mar 2008 18:08:50 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Mike Galbraith <efault@gmx.de>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 00/17] Current sched patch stack
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is just a quick dump of my patch stack that is not already in
sched-devel/master (read: this is on top of sched-devel/master).

These patches are lightly tested - compiled only with a single .config
and booted only. Will repost in somewhat smaller chunks once I get around
to actually testing more.

The newest code (and thus least tested) is the new SMP balancer.

Just posting to get it out-there... :-)

If it breaks you get to keep both (or rather, all) pieces, although I'll try
and fix reported issues in a timely manner.

Patches can also be found here:
  http://programming.kicks-ass.net/kernel-patches/sched-eevdf/

Happy hacking,

/me off to enjoy the last few hours of weekend remaining.
--

