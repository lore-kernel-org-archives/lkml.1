Return-Path: <linux-kernel-owner+w=401wt.eu-S1759156AbYFSMg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759156AbYFSMg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 08:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758167AbYFSMfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 08:35:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:33533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757887AbYFSMfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 08:35:32 -0400
Message-Id: <20080619122218.971447669@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 19 Jun 2008 14:22:18 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "Daniel K." <dk@uw.no>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 00/10] sched: rt bandwidth/group fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

my current queue of fixes

1-4 are pushed into sched-urgent and should be included in .26
the rest are less critical and should be queued for .27



-- 

