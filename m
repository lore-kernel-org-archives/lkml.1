Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab0BLDgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 22:36:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756811Ab0BLDgG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 22:36:06 -0500
Message-ID: <4B74CC5C.7060901@redhat.com>
Date: Thu, 11 Feb 2010 22:34:52 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jim Keniston <jkenisto@us.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
       Andi Kleen <andi@firstfloor.org>, Jason Baron <jbaron@redhat.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>
Subject: Re: [PATCH -tip v9 9/9] kprobes: Add documents of jump optimization
References: <1265914896.5150.21.camel@localhost.localdomain>
In-Reply-To: <1265914896.5150.21.camel@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jim Keniston wrote:
> On Fri, 2010-02-05 at 17:47 -0500, Masami Hiramatsu wrote:
>> Add documentations about kprobe jump optimization to Documentation/kprobes.txt.
> 
> Hi, Masami.  I reviewed your patch, and I recommend the enclosed editorial fixups
> and clarifications.  The enclosed patch is a diff between your version (resulting
> from your patch #9 v9) and mine.  If you incorporate most or all of these changes,
> feel free to mark the result as Signed-off-by or Acked-by me.

Hi Jim,

Thank you very much for reviewing and updating it!
I'll update my patch to include your update. :-)

Thank you again,

> 
> Jim Keniston
-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

