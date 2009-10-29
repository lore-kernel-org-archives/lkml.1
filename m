Return-Path: <linux-kernel-owner+w=401wt.eu-S1756618AbZJ2HLA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbZJ2HLA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 03:11:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJ2HK7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 03:10:59 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:62589 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751739AbZJ2HK7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 03:10:59 -0400
Message-ID: <4AE93FCA.3030203@cn.fujitsu.com>
Date: Thu, 29 Oct 2009 15:10:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, Pavel Machek <pavel@ucw.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Masami Hiramatsu <mhiramat@redhat.com>, Jason Baron <jbaron@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf events: Remove CONFIG_EVENT_PROFILE
References: <4AE93C93.9060607@cn.fujitsu.com> <20091029070731.GD12874@elte.hu>
In-Reply-To: <20091029070731.GD12874@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There's a logistical complication: this rename couples the pending perf 
> tree with the pending tracing tree and that makes dependencies a bit 
> awkward.
> 
> Would you mind to resend this patch in the merge window, to be merged 
> soon after both the perf events and the tracing tree went uptream?
> 
> The rename/elimination itself looks fine and simple and shouldnt break 
> anything, so we dont need to have it in the tracing and perf trees for 
> long.
> 

Sure, I'll keep the patch for now.

