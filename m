Return-Path: <linux-kernel-owner+w=401wt.eu-S1758850AbYEPQoL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758850AbYEPQoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:44:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751673AbYEPQn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:43:57 -0400
Received: from vena.lwn.net ([206.168.112.25]:43077 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751585AbYEPQn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:43:56 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 16 May 2008 09:30:23 PDT."
             <alpine.LFD.1.10.0805160925590.2941@woody.linux-foundation.org> 
Date: Fri, 16 May 2008 10:43:56 -0600
Message-ID: <19345.1210956236@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> May I suggest just adding a comment in those files, just saying something 
> like
> 
> 	/* This does not need the BKL, because .. */

OK, I'll make another pass shortly and fill that in.

> Btw, do you have gitweb running anywhere? 

No, I guess I need to figure out how to set it up.  Either that or get
one of those kernel.org accounts and put things there.

Thanks,

jon
