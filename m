Return-Path: <linux-kernel-owner+w=401wt.eu-S1756228AbYENVvk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756228AbYENVvk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:51:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751309AbYENVvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:51:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:50054 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751072AbYENVvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:51:31 -0400
Date: Wed, 14 May 2008 22:39:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree
Message-ID: <20080514223949.041ca37e@core>
In-Reply-To: <6457.1210801515@vena.lwn.net>
References: <20080514174955.GA515@elte.hu>
	<6457.1210801515@vena.lwn.net>
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

> I kind of like the combination of 2 and 3, done in such a way that
> there's no "every driver must change" flag day.  This could be an
> interesting project, even...  Thoughts?

Its beginning to sound like should start 2.7 ;)

Alan

