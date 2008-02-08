Return-Path: <linux-kernel-owner+w=401wt.eu-S934376AbYBHSUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934376AbYBHSUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 13:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbYBHSUh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 13:20:37 -0500
Received: from py-out-1112.google.com ([64.233.166.180]:3528 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933057AbYBHSUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:20:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=kP0Z9Y3N+sPEwzPmRxsPimHKQ16GF7hgtauBzxbQTXcvzXYQ7yKIMe91pGzeb7Mpa842BxCr3JVAgXHfd1cf3qGu4URY1avZcG5JvR+P0270qX+SiUKTbrTNIgpsCoFyMumKjyjIM3kHnKuUcClJtn/5RScSazqJKxvnL4n/Qog=
Subject: Re: [PATCH] Fix compilation of powerpc asm-offsets.c with old gcc
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Paul Jackson <pj@sgi.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, paulus@samba.org,
       akpm@linux-foundation.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       tony@bakeyournoodle.com
In-Reply-To: <20080208120623.3ad74e3a.pj@sgi.com>
References: <18347.34100.60973.215093@cargo.ozlabs.ibm.com>
	 <alpine.LFD.1.00.0802071449240.2896@woody.linux-foundation.org>
	 <20080208120623.3ad74e3a.pj@sgi.com>
Content-Type: text/plain
Date: Fri, 08 Feb 2008 10:20:26 -0800
Message-Id: <1202494826.31361.49.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-08 at 12:06 -0600, Paul Jackson wrote:
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

Replace <SHA> as needed:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=<SHA>

Harvey

