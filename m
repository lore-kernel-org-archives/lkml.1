Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbYEPQmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbYEPQmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758101AbYEPQgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:36:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45951 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759697AbYEPQgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:36:01 -0400
Date: Fri, 16 May 2008 17:24:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill empty chardev open/release methods
Message-ID: <20080516172414.49fd26b1@core>
In-Reply-To: <20080516160306.GA9103@infradead.org>
References: <alpine.LFD.1.10.0805141452330.3019@woody.linux-foundation.org>
	<16082.1210952646@vena.lwn.net>
	<20080516154922.GA25412@infradead.org>
	<20080516160306.GA9103@infradead.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6/drivers/char/ip2/ip2main.c

Looks fine but please send it via my tty tree so it doesn't collide with
the tty work.

