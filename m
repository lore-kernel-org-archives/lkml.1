Return-Path: <linux-kernel-owner+w=401wt.eu-S1760601AbZDLMPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760601AbZDLMPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 08:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760110AbZDLMPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 08:15:40 -0400
Received: from THUNK.ORG ([69.25.196.29]:56576 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760091AbZDLMPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 08:15:39 -0400
Date: Sun, 12 Apr 2009 08:15:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC 0/3] Improvements to the tracing documentation
Message-ID: <20090412121533.GB10547@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Ingo Molnar <mingo@elte.hu>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>
References: <1239479479-2603-1-git-send-email-tytso@mit.edu> <20090412092524.GA30349@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412092524.GA30349@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 12, 2009 at 11:25:24AM +0200, Ingo Molnar wrote:
> > I'm not sure the documentation is 100% correct, but by 
> > submitting it, hopefully that the tracer authors will get 
> > flushed out of the woodwork and be inspired to improve 
> > what has been submitted.  :-)
> 
> Applied, thanks Ted!
> 
> Patch #1 was already present in the tracing tree - i've 
> added both the event and the power tracer docs to 
> Documentation/trace/.

Thanks for applying it so fast, but did you fix up the spelling and
pathname (Documentation/power.txt was supposed to be
Documentation/trace/power.txt) fixups that folks pointed out?  I was
going to send an v2 update of the patches.  So if you haven't pushed
them out yet, you might want to pull them until I get them fixed up.
Or I can send patches to fix up those issues, whichever is more
convenient for you.

Thanks, regards,

						- Ted
