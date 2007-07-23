Return-Path: <linux-kernel-owner+w=401wt.eu-S1761749AbXGWJNt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761749AbXGWJNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 05:13:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbXGWJNl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 05:13:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45556 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871AbXGWJNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 05:13:40 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0707201835070.27249@woody.linux-foundation.org> <20070717124732.22619.34179.stgit@warthog.cambridge.redhat.com> <20070717175017.8b8a8976.akpm@linux-foundation.org> <469DABA5.9070706@yahoo.com.au> <20070719204102.7b82692d.akpm@linux-foundation.org> <46A04129.1020900@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] AFS: Fix file locking
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Mon, 23 Jul 2007 10:13:29 +0100
Message-ID: <22462.1185182009@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I thought we long long since removed the volatiles.

They're certainly still there in i386 and x86_64.

David
