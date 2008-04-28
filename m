Return-Path: <linux-kernel-owner+w=401wt.eu-S1763409AbYD1ANI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763409AbYD1ANI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 20:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYD1AMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 20:12:54 -0400
Received: from NaN.false.org ([208.75.86.248]:56516 "EHLO nan.false.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYD1AMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 20:12:53 -0400
Date: Sun, 27 Apr 2008 20:12:50 -0400
From: Daniel Jacobowitz <dan@debian.org>
To: Jesper Juhl <jesper.juhl@gmail.com>
Cc: Nick Clifton <nickc@specifixinc.com>, Richard Henderson <rth@redhat.com>,
       Ian Taylor <ian@airs.com>, Jeff Law <law@redhat.com>,
       Jim Wilson <wilson@redhat.com>, DJ Delorie <dj@delorie.com>,
       Alan Modra <amodra@bigpond.net.au>,
       Michael Meissner <meissner@redhat.com>, linux-kernel@vger.kernel.org,
       "Patrick J. Volkerding" <volkerdi@slackware.com>
Subject: Re: ld: <...> internal error, aborting at arange-set.c line 202 in
	arange_set_new
Message-ID: <20080428001250.GA9652@caradoc.them.org>
Mail-Followup-To: Jesper Juhl <jesper.juhl@gmail.com>,
	Nick Clifton <nickc@specifixinc.com>,
	Richard Henderson <rth@redhat.com>, Ian Taylor <ian@airs.com>,
	Jeff Law <law@redhat.com>, Jim Wilson <wilson@redhat.com>,
	DJ Delorie <dj@delorie.com>, Alan Modra <amodra@bigpond.net.au>,
	Michael Meissner <meissner@redhat.com>,
	linux-kernel@vger.kernel.org,
	"Patrick J. Volkerding" <volkerdi@slackware.com>
References: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.00.0804272326320.14738@dragon.funnycrock.com>
User-Agent: Mutt/1.5.17 (2007-12-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 11:35:23PM +0200, Jesper Juhl wrote:
> ld: size of bfd_vma > size of splay_tree types
> ld: BFD (Linux/GNU Binutils) 2.18.50.0.4.20080208 internal error, aborting 
> at arange-set.c line 202 in arange_set_new
> 
> ld: Please report this bug.

I'm pretty sure this is already fixed in HEAD.  If you can reproduce
it with HEAD, please use the binutils mailing list or bugzilla to
report the problem.  Thanks.

-- 
Daniel Jacobowitz
CodeSourcery
