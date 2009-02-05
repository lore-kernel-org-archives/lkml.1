Return-Path: <linux-kernel-owner+w=401wt.eu-S1755833AbZBELdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755833AbZBELdX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:33:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZBELdO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:33:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:39240 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbZBELdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:33:13 -0500
Message-Id: <20090205112414.104100700@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 05 Feb 2009 12:24:14 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: mingo@elte.hu, tglx@linutronix.de, oleg@redhat.com
Cc: linux-kernel@vger.kernel.org, yanmin_zhang@linux.intel.com,
       seto.hidetoshi@jp.fujitsu.com
Subject: [PATCH 0/2] fix the itimer regression (BZ 12618)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should hopefully address all the itimer borkage.

-- 

