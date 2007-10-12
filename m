Return-Path: <linux-kernel-owner+w=401wt.eu-S1760395AbXJLJy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760395AbXJLJy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758822AbXJLJyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:54:18 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3462 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbXJLJyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:54:17 -0400
Date: Fri, 12 Oct 2007 04:54:06 -0500 (CDT)
From: Milton Miller <miltonm@bga.com>
Subject: [PATCH] sched domain debug sysctl fixes
In-Reply-To: <mm-sched-0@bga.com>
Message-Id: <mm-sched-6@bga.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


I forgot to put the seqence numbers in the patch subjects (I did
in the message ids).

Here is the order I diffed them:

sched domain sysctl: register online cpus
sched domain sysctl: free and rebuild when changing domains
sched.c: use kcalloc
sched domain sysctl: don't bug on alloc failure
sched domain sysctl: sysctl tables can have no holes

milton
