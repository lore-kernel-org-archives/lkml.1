Return-Path: <linux-kernel-owner+w=401wt.eu-S1759173AbYBRKBs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759173AbYBRKBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:01:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYBRJ73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 04:59:29 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:55147 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755610AbYBRJ70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 04:59:26 -0500
Message-Id: <20080218095535.629736000@chello.nl>
User-Agent: quilt/0.45-1
Date: Mon, 18 Feb 2008 10:55:35 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       dhaval@linux.vnet.ibm.com, tong.n.li@intel.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] Single RQ group scheduling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is my current queue for single RQ group scheduling.

Next on the list is the SMP load balancing, for that I'm looking at Tong's
DWRR algorithm.


