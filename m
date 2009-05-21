Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbZEUTIg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbZEUTIg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:08:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbZEUTI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:08:28 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751881AbZEUTI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:08:27 -0400
Message-ID: <4A15A708.9090306@redhat.com>
Date: Thu, 21 May 2009 15:10:00 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>, kvm <kvm@vger.kernel.org>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Vegard Nossum <vegard.nossum@gmail.com>, Avi Kivity <avi@redhat.com>,
       =?UTF-8?B?UHJ6ZW15c8WCYXdQYXdlxYJjenlr?= <przemyslaw@pawelczyk.it>
Subject: Re: [PATCH -tip v6.1 1/5] x86: instruction decoder API
References: <4A1578A5.7090608@redhat.com> <20090521172907.1313.38072.stgit@localhost.localdomain> <4A158F86.6@linux.intel.com>
In-Reply-To: <4A158F86.6@linux.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> This might be an unimportant detail, but I would suggest to fix the
> "decorder" typo in the Subject before the next revision. It seems
> to have persisted over 6 revisions now, but it still irritatess me @)

Oops, sorry...

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

