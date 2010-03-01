Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab0CAD6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 22:58:21 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753914Ab0CAD6S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 22:58:18 -0500
Date: Sun, 28 Feb 2010 19:57:18 -0800
From: Greg KH <gregkh@suse.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andrea Gelmini <andrea.gelmini@gelma.net>, Jeff Dike <jdike@addtoit.com>,
       linux-kernel@vger.kernel.org,
       user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH 66/66]
 arch/um/sys-x86_64/shared/sysdep/skas_ptrace.h: Checkpatch cleanup
Message-ID: <20100301035718.GA17045@suse.de>
References: <1267289508-31031-1-git-send-email-andrea.gelmini@gelma.net>
 <1267289508-31031-67-git-send-email-andrea.gelmini@gelma.net>
 <20100227221310.GA5455@localhost.localdomain>
 <9cdbb57f1002280606j6d6ca697k21f42cff87d685de@mail.gmail.com>
 <20100228204506.GQ30031@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100228204506.GQ30031@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 28, 2010 at 08:45:06PM +0000, Al Viro wrote:
> On Sun, Feb 28, 2010 at 03:06:21PM +0100, Andrea Gelmini wrote:
> > 2010/2/27 Jeff Dike <jdike@addtoit.com>:
> > Hi Jeff,
> >    and thanks for your reply.
> > 
> > > Don't you have anything better to do with your time?
> > 
> > It's a dirty job, but somebody has to do it...
> > Enlighted by Greg's talk at FOSDEM?? I sent him some patches (nothing
> > more than boring things for a real programmer, but a good solitaire
> > alternative for a rookie like me).
> > 
> > These patches are just a try to see if there are other subtree
> > maintainers interested in stuff like this.
> 
> Note to gregkh: the next time you give a talk like that, consider including
> "spamming l-k with sixty-odd solitaire sessions^W^Wwhitespace-removal patches
> can lead to considerable annoyance"...

Heh, I did explicitly state that this should be done on the staging
tree only.  This developer took it apon themselves to try a different
subsystem, which is fine, why would we want to turn away free help :)

thanks,

greg k-h
