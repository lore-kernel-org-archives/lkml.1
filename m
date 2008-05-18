Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYERUH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYERUH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 16:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753826AbYERUHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 16:07:15 -0400
Received: from vena.lwn.net ([206.168.112.25]:43284 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505AbYERUHO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 16:07:14 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, RFC] char dev BKL pushdown 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Sat, 17 May 2008 14:58:17 PDT."
             <alpine.LFD.1.10.0805171452340.3020@woody.linux-foundation.org> 
Date: Sun, 18 May 2008 14:07:13 -0600
Message-ID: <12829.1211141233@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Btw, Jonathan, would you be willing to maintain some kind of tree of these 
> BKL removal patches? 

Sure, I can do that - as long as people don't mind that committed to
being with the in-laws and off the net for the first couple of weeks in
June.  I'll try to get the first version up shortly, after yet another
pass over the chardev pushdown stuff.

jon
