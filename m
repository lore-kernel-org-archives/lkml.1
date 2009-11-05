Return-Path: <linux-kernel-owner+w=401wt.eu-S1757213AbZKEONa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213AbZKEONa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 09:13:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757153AbZKEONa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 09:13:30 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:42988 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150AbZKEON3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 09:13:29 -0500
Date: Thu, 5 Nov 2009 19:43:21 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@web.de>,
       Jiri Slaby <jirislaby@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Avi Kivity <avi@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Mike Galbraith <efault@gmx.de>, Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>
Subject: Re: [GIT PULL v4] hw-breakpoints: Rewrite on top of perf events v4
Message-ID: <20091105141321.GA3229@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257275474-5285-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 03, 2009 at 08:11:08PM +0100, Frederic Weisbecker wrote:
> Hi all,
> 
> This is the v4 of the hw-breakpoints API rewrite on top of perf events.
> 
> This integrates the following fixes:
>

Is there a missing patch 2/6 or are they numbered incorrectly? I see a
patch 1/6 followed by 3/6.

Thanks,
K.Prasad
 
