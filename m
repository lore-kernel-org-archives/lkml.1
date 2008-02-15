Return-Path: <linux-kernel-owner+w=401wt.eu-S933784AbYBOLW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933784AbYBOLW7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 06:22:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758129AbYBOLWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 06:22:52 -0500
Received: from viefep20-int.chello.at ([62.179.121.40]:48973 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbYBOLWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 06:22:51 -0500
Message-Id: <20080215111819.978881000@chello.nl>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:18:20 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] for sched-devel.git
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Would you stick these into sched-devel.

The first patch should address the latency isolation issue. While the second
rectifies a massive brainfart :-)



