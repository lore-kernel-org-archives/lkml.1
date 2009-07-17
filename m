Return-Path: <linux-kernel-owner+w=401wt.eu-S1757880AbZGQVTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757880AbZGQVTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 17:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757861AbZGQVTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 17:19:41 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:34962 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757860AbZGQVTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 17:19:41 -0400
Date: Fri, 17 Jul 2009 23:19:39 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Anders Kaseorg <andersk@ksplice.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: Re: [RFC][ PATCH -tip v2 3/7] Kbuild: disable gcc crossjumping
Message-ID: <20090717211939.GA7253@merkur.ravnborg.org>
Mail-Followup-To: Masami Hiramatsu <mhiramat@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	lkml <linux-kernel@vger.kernel.org>,
	systemtap <systemtap@sources.redhat.com>,
	DLE <dle-develop@lists.sourceforge.net>,
	Jim Keniston <jkenisto@us.ibm.com>,
	Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
	Christoph Hellwig <hch@infradead.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Anders Kaseorg <andersk@ksplice.com>,
	Tim Abbott <tabbott@ksplice.com>
References: <20090622212255.5384.53732.stgit@localhost.localdomain> <20090622212313.5384.84166.stgit@localhost.localdomain> <alpine.DEB.2.00.0906271611280.12592@gandalf.stny.rr.com> <20090717202825.GA6872@merkur.ravnborg.org> <4A60E972.1060301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A60E972.1060301@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 05:13:22PM -0400, Masami Hiramatsu wrote:
> Sam Ravnborg wrote:
> > On Sat, Jun 27, 2009 at 04:13:04PM -0400, Steven Rostedt wrote:
> >> A change like this requires an ACK from Sam Ravnborg.
> >>
> >> -- Steve
> > 
> > Overdue review...
> > 
> > I do not know the gcc option so I cannot comment on theeffect of it.
> 
> Thanks for comment. however, as far as I can see, I couldn't find
> in the difference between binary with -fno-crossjump and without it.
> So I decided to drop this patch...

OK, thanks or info.

	Sam
