Return-Path: <linux-kernel-owner+w=401wt.eu-S1763575AbXJEPsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763575AbXJEPsA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 11:48:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757205AbXJEPrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 11:47:51 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756405AbXJEPru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 11:47:50 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20071005144605.GA3072@infradead.org>
References: <20071005144605.GA3072@infradead.org> <20071004155602.2814.47731.stgit@warthog.procyon.org.uk> <20071004155607.2814.74947.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, viro@ftp.linux.org.uk, torvalds@osdl.org,
       akpm@osdl.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 01/32] Add an ERR_CAST() macro to complement ERR_PTR and co. [try #2]
X-Mailer: MH-E 8.0.3; nmh 1.2-20070115cvs; GNU Emacs 22.1.50
Date: Fri, 05 Oct 2007 16:47:36 +0100
Message-ID: <17643.1191599256@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> I don't like this one very much, I'd rather take the variant Linus
> outline in his last post on that topic..

I'd rather not take that variant.

David
