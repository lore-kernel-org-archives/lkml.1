Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZL2FWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZL2FWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 00:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751601AbZL2FWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 00:22:46 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54764 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751533AbZL2FWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 00:22:45 -0500
Message-ID: <4B3991B2.8060207@cn.fujitsu.com>
Date: Tue, 29 Dec 2009 13:20:50 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, Paul Mackerras <paulus@samba.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v3 0/5] perf tools: introduce 'perf timer' to analyze timer's
 behavior
References: <4B27702F.1080507@cn.fujitsu.com> <20091215142325.GC5833@nowhere> <4B30C2D1.4030006@cn.fujitsu.com> <4B30C3A0.909@cn.fujitsu.com> <20091228075417.GB20039@elte.hu>
In-Reply-To: <20091228075417.GB20039@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changelog v2->v3:

introduce 'inject' event to get kernel HZ address Ingo's suggestion
[ see http://lkml.org/lkml/2009/12/28/31 ]
