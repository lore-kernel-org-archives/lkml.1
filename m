Return-Path: <linux-kernel-owner+w=401wt.eu-S1755686AbXJCAMp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbXJCAMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 20:12:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753214AbXJCAMg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 20:12:36 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46572 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752755AbXJCAMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 20:12:35 -0400
Date: Wed, 3 Oct 2007 01:12:46 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Bill Davidsen <davidsen@tmr.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       James Morris <jmorris@namei.org>,
       Andrew Morton <akpm@linux-foundation.org>, casey@schaufler-ca.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Version 3 (2.6.23-rc8) Smack: Simplified Mandatory
 Access   Control Kernel
Message-ID: <20071003011246.7313facb@the-village.bc.nu>
In-Reply-To: <alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org>
References: <46FEEBD4.5050401@schaufler-ca.com>
	<20070930011618.ccb8351b.akpm@linux-foundation.org>
	<Xine.LNX.4.64.0710010146100.13671@us.intercode.com.au>
	<alpine.LFD.0.999.0710010803280.3579@woody.linux-foundation.org>
	<1191253239.7672.76.camel@moss-spartans.epoch.ncsc.mil>
	<alpine.LFD.0.999.0710010854120.3579@woody.linux-foundation.org>
	<4702B1D5.5050502@tmr.com>
	<alpine.LFD.0.999.0710021410470.3579@woody.linux-foundation.org>
	<alpine.LFD.0.999.0710021615520.3579@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> situations. For example, I find SELinux to be so irrelevant to my usage 
> that I don't use it at all. I just don't have any other users on my 
> machine

That you know about...

The value of SELinux (or indeed any system compartmentalising access and
limiting damage) comes into play when you get breakage - eg via a web
browser exploit.

Yes SELinux is much more relevant to servers, and really comes into its
own when its used to write custom rulesets and enforce corporate policy
("No you can't run that screensaver that arrived by email").

Alan
