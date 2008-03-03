Return-Path: <linux-kernel-owner+w=401wt.eu-S1754014AbYCCMRK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbYCCMRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 07:17:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbYCCMQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 07:16:56 -0500
Received: from mx1.redhat.com ([66.187.233.31]:50880 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbYCCMQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 07:16:56 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080303114310.GA28139@flint.arm.linux.org.uk>
References: <20080303114310.GA28139@flint.arm.linux.org.uk> <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <8260.1204541852@redhat.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: dhowells@redhat.com, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       David Brownell <dbrownell@users.sourceforge.net>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Mon, 03 Mar 2008 12:15:59 +0000
Message-ID: <8809.1204546559@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> > And #if defined(__ASSEMBLY__), just splat x through as is.
> 
> We already have something like this on ARM - include/asm-arm/memory.h

Which you could perhaps replace.

David
