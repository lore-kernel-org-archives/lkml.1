Return-Path: <linux-kernel-owner+w=401wt.eu-S935604AbYBHSJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935604AbYBHSJs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935041AbYBHSGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:06:31 -0500
Received: from relay1.sgi.com ([192.48.171.29]:34273 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S935034AbYBHSG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:06:29 -0500
Date: Fri, 8 Feb 2008 12:06:23 -0600
From: Paul Jackson <pj@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: paulus@samba.org, akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tony@bakeyournoodle.com
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
Message-Id: <20080208120623.3ad74e3a.pj@sgi.com>
In-Reply-To: <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
	<alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus wrote:
> Please, when mentioning hex numbers, also do the one-liner shortlog.
> ...
> without _requiring_ people to be git users to get the gist of the 
> matter, ok?


Thanks for sticking up for us git-challenged contributors.

Can anyone point me at instructions providing the shortest
path for getting from one of those git hex numbers to the
log or change it represents, for non-git users?

Or do those instructions begin with a first step of:

  1. become a git user
  2. ...

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
