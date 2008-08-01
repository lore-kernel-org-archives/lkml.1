Return-Path: <linux-kernel-owner+w=401wt.eu-S1759563AbYHAUOb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563AbYHAUOb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 16:14:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758033AbYHAUOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 16:14:16 -0400
Received: from fwil.voltaire.com ([193.47.165.2]:35581 "EHLO exil.voltaire.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757460AbYHAUOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 16:14:16 -0400
Date: Fri, 1 Aug 2008 23:14:10 +0300 (IDT)
From: Or Gerlitz <ogerlitz@voltaire.com>
To: bunk@kernel.org
cc: linux-kernel@vger.kernel.org
Subject: Re: error building linus tree (2.6.27-rc1)
In-Reply-To: <Pine.LNX.4.64.0807292357040.3348@zuben.voltaire.com>
Message-ID: <Pine.LNX.4.64.0808012312260.10651@zuben.voltaire.com>
References: <Pine.LNX.4.64.0807292357040.3348@zuben.voltaire.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-OriginalArrivalTime: 01 Aug 2008 20:14:11.0010 (UTC) FILETIME=[29097220:01C8F413]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jul 2008, Or Gerlitz wrote:

> I get into this
> arch/x86/kernel/ldt.c: In function `alloc_ldt':
> arch/x86/kernel/ldt.c:67: error: invalid lvalue in unary `&'

Here's the gcc and as versions

$ gcc --version
gcc (GCC) 3.4.6 20060404 (Red Hat 3.4.6-8)
Copyright (C) 2006 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ as --version

GNU assembler 2.15.92.0.2 20040927
Copyright 2002 Free Software Foundation, Inc.
This program is free software; you may redistribute it under the terms of
the GNU General Public License.  This program has absolutely no warranty.
This assembler was configured for a target of `x86_64-redhat-linux'.

Or.
