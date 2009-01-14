Return-Path: <linux-kernel-owner+w=401wt.eu-S1755798AbZANGUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798AbZANGUK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 01:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbZANGT5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 01:19:57 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:3082 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbZANGT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 01:19:56 -0500
Subject: Re: [PATCH 08/10] MAINTAINERS - Add FTRACE git
From: Joe Perches <joe@perches.com>
To: Paul Mundt <lethal@linux-sh.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090114055954.GA7039@linux-sh.org>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
	 <1231878498-25171-9-git-send-email-joe@perches.com>
	 <20090114055954.GA7039@linux-sh.org>
Content-Type: text/plain
Date: Tue, 13 Jan 2009 22:19:47 -0800
Message-Id: <1231913987.30095.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2-1.2mdv2009.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-14 at 14:59 +0900, Paul Mundt wrote:
> On Tue, Jan 13, 2009 at 12:28:16PM -0800, Joe Perches wrote:
> > Signed-off-by: Joe Perches <joe@perches.com>
> > ---
> >  MAINTAINERS |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ceeeb8c..6e051c3 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -2189,6 +2189,7 @@ F:	fs/freevxfs/
> >  FTRACE
> >  P:	Steven Rostedt
> >  M:	rostedt@goodmis.org
> > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
> >  S:	Maintained
> >  F:	Documentation/ftrace.txt
> >  F:	arch/*/*/*/ftrace.h
> 
> This sort of thing only makes sense if you include the topic branch for
> the tree in question. While it is true that ftrace development happens in
> this tree, people looking at ftrace may not want to sort through the
> hundreds of unrelated topic branches in the process. I say this as
> someone that does not want to sort through hundreds of unrelated topic
> branches in search of ftrace code ;-)

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=heads

Is the correct topic branch for ftrace auto-ftrace-next?

maybe:

T:	git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git auto-ftrace-next

No idea what's right here.  I had some private emails
with Steven Rostedt about a git tree.  He suggested
to use tip.

Steven?  Suggestions?

