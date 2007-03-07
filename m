Return-Path: <linux-kernel-owner+w=401wt.eu-S1161216AbXCGCGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161216AbXCGCGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161215AbXCGCGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:06:52 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:42340 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161212AbXCGCGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:06:52 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 6 Mar 2007 18:06:49 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] epoll optimizations and cleanups  ...
In-Reply-To: <Pine.LNX.4.64.0703061803140.5963@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703061805550.3661@alien.or.mcafeemobile.com>
References: <Pine.LNX.4.64.0703061616550.3661@alien.or.mcafeemobile.com>
 <Pine.LNX.4.64.0703061803140.5963@woody.linux-foundation.org>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2007, Linus Torvalds wrote:

> On Tue, 6 Mar 2007, Davide Libenzi wrote:
> > 
> > This patch is the same as the v3 posted before, and removes multiple 
> > passes over the ready set.
> 
> Can you put a nicer Subject: message, rather than giving all three patches 
> the same Subject.
> 
> I'm assuming this will all go through Andrew anyway, but at least my tools 
> (and I assume Andrew's too) will take the Subject: line and make it into 
> the short description. So if you give a nondescriptive subject line, the 
> short description will be bad too.
> 
> So please make the subject line really be about that *particular* patch.

Yes, Andrew already chewed my a** for that ;)



- Davide


