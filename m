Return-Path: <linux-kernel-owner+w=401wt.eu-S1758819AbZKEUas@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819AbZKEUas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 15:30:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758611AbZKEUar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 15:30:47 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:60783 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592AbZKEUaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 15:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kKD0nGDdthWJIglBdb22ij3GBcn/jfdCghMnB7lZ/K9OeneHC9TAAwmnQmEqx/nub5
         oz38cW4uE3fEU6k5iiSXapaWDgY4cKnJI63h8qe4Sl32P8Pap1TxtjibjyRQTdv+9NKT
         mUKODItthWBhqO3xwWcf2LxDcseD2KCQcnL3M=
Date: Thu, 5 Nov 2009 21:30:51 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
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
Message-ID: <20091105203048.GE4877@nowhere>
References: <1257275474-5285-1-git-send-email-fweisbec@gmail.com> <20091105141321.GA3229@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091105141321.GA3229@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 05, 2009 at 07:43:21PM +0530, K.Prasad wrote:
> On Tue, Nov 03, 2009 at 08:11:08PM +0100, Frederic Weisbecker wrote:
> > Hi all,
> > 
> > This is the v4 of the hw-breakpoints API rewrite on top of perf events.
> > 
> > This integrates the following fixes:
> >
> 
> Is there a missing patch 2/6 or are they numbered incorrectly? I see a
> patch 1/6 followed by 3/6.
> 
> Thanks,
> K.Prasad
>  


Yeah, that's the problem with git-send-email, it appends
the emails in the Cc list using the Cc: tags but it doesn't
take the other tags (may be just the Signed-off-by).

And you've acked this one, but I haven't put you in the Cc tag.
I should have, sorry. You can find it there:

http://lkml.org/lkml/2009/11/3/340

