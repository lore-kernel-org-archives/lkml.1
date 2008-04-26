Return-Path: <linux-kernel-owner+w=401wt.eu-S1758570AbYDZP7t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570AbYDZP7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:59:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbYDZP7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:59:41 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49708 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941AbYDZP7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:59:40 -0400
Date: Sat, 26 Apr 2008 09:59:39 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Announce: Semaphore-Removal tree
Message-ID: <20080426155939.GQ14990@parisc-linux.org>
References: <20080425170021.GH14990@parisc-linux.org> <20080426235439.52031d35.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080426235439.52031d35.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 11:54:39PM +1000, Stephen Rothwell wrote:
> Hi Willy,
> 
> On Fri, 25 Apr 2008 11:00:21 -0600 Matthew Wilcox <matthew@wil.cx> wrote:
> >
> > Stephen, could you pick these patches up for linux-next?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/willy/misc.git semaphore-removal
> 
> This is in addition to the semaphore branch? Should it go before or after
> that i.e. does it depend on it?

It's in addition to, and it's independent of it.  I don't intend to
create any conflicts or dependencies between them.  In case I do ...
let's say semaphore-removal goes after semaphore.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
