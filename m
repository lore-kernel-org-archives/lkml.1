Return-Path: <linux-kernel-owner+w=401wt.eu-S934667AbYD1Nzz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667AbYD1Nzz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 09:55:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933246AbYD1Nzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 09:55:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933359AbYD1Nzp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 09:55:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LNX.1.10.0804252143170.20150@fbirervta.pbzchgretzou.qr>
References: <alpine.LNX.1.10.0804252143170.20150@fbirervta.pbzchgretzou.qr> <1209078352-7593-1-git-send-email-hpa@zytor.com> <1209078352-7593-2-git-send-email-hpa@zytor.com> <1209078352-7593-3-git-send-email-hpa@zytor.com> <alpine.LNX.1.10.0804252026040.20150@fbirervta.pbzchgretzou.qr> <alpine.LFD.1.10.0804251133100.2779@woody.linux-foundation.org> <20080425185251.GL14990@parisc-linux.org> <48122CB0.7020003@zytor.com> <20080425192858.GM14990@parisc-linux.org> <48123325.30003@zytor.com> 
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: dhowells@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 01/24] types: create <asm-generic/int-*.h>
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 28 Apr 2008 14:55:37 +0100
Message-ID: <4489.1209390937@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt <jengelh@computergmbh.de> wrote:

> In the kernel's *printk, we are free to do what we want :)

Subject to -Wformat in gcc, of course...

David
