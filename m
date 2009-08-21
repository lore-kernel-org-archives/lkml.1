Return-Path: <linux-kernel-owner+w=401wt.eu-S932741AbZHUUer@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932741AbZHUUer (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Aug 2009 16:34:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932499AbZHUUep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Aug 2009 16:34:45 -0400
Received: from kroah.org ([198.145.64.141]:41057 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932716AbZHUUen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Aug 2009 16:34:43 -0400
Date: Fri, 21 Aug 2009 13:32:25 -0700
From: Greg KH <greg@kroah.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Arjan van de Ven <arjan@infradead.org>,
       "Luis R. Rodriguez" <mcgrof@gmail.com>, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 00/14] kconfig: streamline distro configs for testers
Message-ID: <20090821203225.GA30866@kroah.com>
References: <20090819025634.987354707@goodmis.org>
 <20090821143525.GH11098@elte.hu>
 <alpine.DEB.2.00.0908211047160.16405@gandalf.stny.rr.com>
 <20090821145406.GA3659@elte.hu>
 <alpine.DEB.2.00.0908211200160.30182@gandalf.stny.rr.com>
 <alpine.DEB.2.00.0908211204490.30182@gandalf.stny.rr.com>
 <20090821162822.GA20898@elte.hu>
 <alpine.DEB.2.00.0908211253080.30182@gandalf.stny.rr.com>
 <20090821195131.GE5356@elte.hu>
 <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0908211601000.30182@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 21, 2009 at 04:12:18PM -0400, Steven Rostedt wrote:
> 
> This seems to be a very useful tool. I don't want to prevent it from going 
> further because we try to make it do too much. Lets get what we have now 
> in, and then we can look at alternatives.

I totally agree.  It is useful as-is and should go in for the
functionality it has today.

thanks,

greg k-h
