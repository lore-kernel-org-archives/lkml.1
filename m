Return-Path: <linux-kernel-owner+w=401wt.eu-S1753018AbYJaQc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbYJaQc7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 12:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751543AbYJaQcv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 12:32:51 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:47439 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbYJaQcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 12:32:50 -0400
Date: Fri, 31 Oct 2008 09:31:52 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] ftrace: update txt document
Message-Id: <20081031093152.efbb65c1.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
References: <alpine.DEB.1.10.0810231921590.4182@gandalf.stny.rr.com>
	<20081026193339.91e0c644.randy.dunlap@oracle.com>
	<alpine.DEB.1.10.0810311102280.20404@gandalf.stny.rr.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2008 11:03:43 -0400 (EDT) Steven Rostedt wrote:

> [
>   Changes since v1:
> 
>   Addressed most of Randy Dunlap's comments.
> ]
> 
> A lot of changes have gone into ftrace. This patch updates
> the ftrace.txt document.
> 
> Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> ---
>  Documentation/ftrace.txt |  169 ++++++++++++++++++++---------------------------
>  1 file changed, 72 insertions(+), 97 deletions(-)

Looks good.  Thanks for the updates.
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

---
~Randy
