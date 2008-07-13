Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYGMIzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYGMIzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 04:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYGMIzY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 04:55:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40623 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752735AbYGMIzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 04:55:23 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080712221625.4461f2e6.akpm@linux-foundation.org>
References: <20080712221625.4461f2e6.akpm@linux-foundation.org> <20080711143648.19650.93895.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, bjorn.helgaas@hp.com, kkeil@suse.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Sun, 13 Jul 2008 09:54:35 +0100
Message-ID: <16628.1215939275@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Does this fix a build error or a warning or what?  A warning, I think.

An unused variable warning.

David
