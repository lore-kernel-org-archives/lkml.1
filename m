Return-Path: <linux-kernel-owner+w=401wt.eu-S1763720AbYBTFxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763720AbYBTFxg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 00:53:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbYBTFxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 00:53:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:49115 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938AbYBTFxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 00:53:16 -0500
Date: Tue, 19 Feb 2008 21:50:55 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 20
Message-ID: <20080220055055.GC31832@kroah.com>
References: <20080220163457.79b9189f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080220163457.79b9189f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2008 at 04:34:57PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git.
> 
> You can see which trees have been included by looking in the Next/Trees
> file in the source.  There are also quilt-import.log and merge.log files
> in the Next directory.  Between each merge, the tree was built with
> allmodconfig for both powerpc and x86_64.

What's the best way to constantly follow this tree?  I had cloned it a
while ago, but now if I 'git pull' it wants to merge things, which isn't
right.

I'm guessing that this is constantly being rebased?  Against what,
Linus's tree?  So we should be able to clone Linus's tree, and then pull
in -next?

Or am I totally missing something here?

> There were no merge conflicts and only one build failure!
> 
> We are up to 27 trees, more are welcome (even if they are currently
> empty).  I would encourage architecture maintainers, in particular, to
> set up a git branch or quilt tree now to avoid the rush after RC2 :-)
> 
> I will stop making these announcements now unless there is some change to
> the tree or things people should know.  There should be a new tree every
> (Australian Capital Territory) working day.

I like seeing these, to know that things are at least still working.  I
imagine you could script them, or just send them to the linux-next list
if there are no problems, but lkml should probably be notified of any
issues, right?

thanks,

greg k-h
