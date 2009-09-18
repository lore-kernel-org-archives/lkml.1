Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZIRDqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZIRDqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 23:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbZIRDqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 23:46:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60405 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbZIRDqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 23:46:15 -0400
Message-ID: <4AB3023E.7040904@cn.fujitsu.com>
Date: Fri, 18 Sep 2009 11:45:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Jason Baron <jbaron@redhat.com>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: Re: [PATCH 1/2] tracing: Factorize the events profile accounting
References: <1253237613-5589-1-git-send-email-fweisbec@gmail.com> <1253237613-5589-2-git-send-email-fweisbec@gmail.com>
In-Reply-To: <1253237613-5589-2-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Factorize the events enabling accounting in a common tracing core
> helper. This reduces the size of the profile_enable() and
> profile_disable() callbacks for each trace events.
> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

