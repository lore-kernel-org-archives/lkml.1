Return-Path: <linux-kernel-owner+w=401wt.eu-S1161209AbXCGCE7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161209AbXCGCE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 21:04:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161210AbXCGCE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 21:04:59 -0500
Received: from smtp.osdl.org ([65.172.181.24]:43092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161209AbXCGCE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 21:04:58 -0500
Date: Tue, 6 Mar 2007 18:04:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davide Libenzi <davidel@xmailserver.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/3] epoll optimizations and cleanups  ...
In-Reply-To: <Pine.LNX.4.64.0703061616550.3661@alien.or.mcafeemobile.com>
Message-ID: <Pine.LNX.4.64.0703061803140.5963@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0703061616550.3661@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Mar 2007, Davide Libenzi wrote:
> 
> This patch is the same as the v3 posted before, and removes multiple 
> passes over the ready set.

Can you put a nicer Subject: message, rather than giving all three patches 
the same Subject.

I'm assuming this will all go through Andrew anyway, but at least my tools 
(and I assume Andrew's too) will take the Subject: line and make it into 
the short description. So if you give a nondescriptive subject line, the 
short description will be bad too.

So please make the subject line really be about that *particular* patch.

		Linus
