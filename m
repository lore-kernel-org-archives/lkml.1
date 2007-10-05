Return-Path: <linux-kernel-owner+w=401wt.eu-S1763271AbXJEQUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763271AbXJEQUb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:20:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbXJEQUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:20:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbXJEQUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:20:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071005160750.GA31413@uranus.ravnborg.org>
References: <20071005160750.GA31413@uranus.ravnborg.org> <20071005144605.GA3072@infradead.org> <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155607.2814.74947.stgit@warthog.procyon.org.uk> <17643.1191599256@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: dhowells@redhat.com, Christoph Hellwig <hch@infradead.org>,
       viro@ftp.linux.org.uk, torvalds@osdl.org, akpm@osdl.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and co. [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 05 Oct 2007 17:19:47 +0100
Message-ID: <17910.1191601187@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg <sam@ravnborg.org> wrote:

> One like one variant, another like another variant.
> Both fails to say why.

It's shorter, more compact, and of course requires the least amount of change
(especially as I can automate it with a command line perl script).

David
