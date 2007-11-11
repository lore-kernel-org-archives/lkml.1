Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbXKKOCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbXKKOCP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 09:02:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751652AbXKKOCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 09:02:00 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434AbXKKOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 09:02:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1194667538.2588.49.camel@shinybook.infradead.org>
References: <1194667538.2588.49.camel@shinybook.infradead.org> <20071109153432.20803.69832.stgit@warthog.procyon.org.uk> <20071109153503.20803.69203.stgit@warthog.procyon.org.uk>
To: David Woodhouse <dwmw2@infradead.org>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-am33-list@redhat.com
Subject: Re: [PATCH 6/6] MN10300: Add MTD flash support for the ASB2303 board [try #5]
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Sun, 11 Nov 2007 14:01:50 +0000
Message-ID: <1529.1194789710@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse <dwmw2@infradead.org> wrote:

> Dunno why it's called "try #5" when I haven't directly received it even
> once yet.

As far as LKML is concerned, it's part of patchset try #5.

> We're trying to avoid taking new simple map drivers -- you should be
> able to use a platform device instead.

Example?

David
