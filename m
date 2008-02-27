Return-Path: <linux-kernel-owner+w=401wt.eu-S1762165AbYB0W10@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762165AbYB0W10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 17:27:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758773AbYB0W02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 17:26:28 -0500
Received: from viefep25-int.chello.at ([62.179.121.45]:21363 "EHLO
	viefep25-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755469AbYB0W01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 17:26:27 -0500
X-SourceIP: 80.56.237.116
Message-Id: <20080227222103.673194000@chello.nl>
User-Agent: quilt/0.45-1
Date: Wed, 27 Feb 2008 23:21:03 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Oleg Nesterov <oleg@tv-sign.ru>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Jackson <pj@sgi.com>, Max Krasnyanskiy <maxk@qualcomm.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC/PATCH 0/4] CPUSET driven CPU isolation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My vision on the direction we should take wrt cpu isolation.

Next on the list would be figuring out a nice solution to the workqueue
flush issue.

