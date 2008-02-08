Return-Path: <linux-kernel-owner+w=401wt.eu-S935136AbYBHS0H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935136AbYBHS0H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:26:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934835AbYBHSZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:25:24 -0500
Received: from smtp.cs.aau.dk ([130.225.194.6]:37480 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934801AbYBHSZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:25:22 -0500
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Paul Jackson <pj@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tony@bakeyournoodle.com
In-Reply-To: <20080208120623.3ad74e3a.pj@sgi.com>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
	 <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
	 <20080208120623.3ad74e3a.pj@sgi.com>
Content-Type: text/plain; charset=utf-8
Date: Fri, 08 Feb 2008 19:31:04 +0100
Message-Id: <1202495464.6722.13.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


fre, 08 02 2008 kl. 12:06 -0600, skrev Paul Jackson:
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

Use gitweb [1], Linus' tree is here [2]. Just search for the hex.

[1] http://git.kernel.org/
[2]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=summary


Simon Holm Thøgersen

