Return-Path: <linux-kernel-owner+w=401wt.eu-S1757341AbYACTOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757341AbYACTOo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 14:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753181AbYACTOW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 14:14:22 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:47884 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753180AbYACTOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 14:14:21 -0500
Message-Id: <20080103191300.658221000@chello.nl>
User-Agent: quilt/0.45-1
Date: Thu, 03 Jan 2008 20:13:00 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/2] rt group sched updates
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

against sched-devel

--

