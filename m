Return-Path: <linux-kernel-owner+w=401wt.eu-S1751897AbYLCJi7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897AbYLCJi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 04:38:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbYLCJiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 04:38:46 -0500
Received: from mail.windriver.com ([147.11.1.11]:47353 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbYLCJiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 04:38:46 -0500
Message-ID: <49364F93.7030007@windriver.com>
Date: Wed, 03 Dec 2008 17:21:23 +0800
From: Wang Liming <liming.wang@windriver.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/5] ftrace: replace raw_local_irq_save with local_irq_save
References: <20081202203404.496794864@goodmis.org> <20081202203424.606667175@goodmis.org>
In-Reply-To: <20081202203424.606667175@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Dec 2008 09:37:21.0171 (UTC) FILETIME=[BD6BB630:01C9552A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Ingo,

Where could I find define of "local_irq_save" for x86 if 
CONFIG_TRACE_IRQFLAGS_SUPPORT is not defined?


Liming Wang
