Return-Path: <linux-kernel-owner+w=401wt.eu-S933195AbYBHSUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195AbYBHSUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759538AbYBHSU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:20:27 -0500
Received: from lixom.net ([66.141.50.11]:48546 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757798AbYBHSU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:20:26 -0500
Date: Fri, 8 Feb 2008 12:21:54 -0600
From: Olof Johansson <olof@lixom.net>
To: Paul Jackson <pj@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, paulus@samba.org,
       akpm@linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
Message-ID: <20080208182154.GA10295@lixom.net>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com> <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org> <20080208120623.3ad74e3a.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080208120623.3ad74e3a.pj@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2008 at 12:06:23PM -0600, Paul Jackson wrote:
> Linus wrote:
> > Please, when mentioning hex numbers, also do the one-liner shortlog.
> > ...
> > without _requiring_ people to be git users to get the gist of the 
> > matter, ok?
> 
> 
> Thanks for sticking up for us git-challenged contributors.
> 
> Can anyone point me at instructions providing the shortest
> path for getting from one of those git hex numbers to the
> log or change it represents, for non-git users?
> 
> Or do those instructions begin with a first step of:
> 
>   1. become a git user
>   2. ...

Does this count?

1. Go to http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git
2. Enter the SHA string in the 'search' field at the top right


-Olo
