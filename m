Return-Path: <linux-kernel-owner+w=401wt.eu-S1423378AbXDYT5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423378AbXDYT5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 15:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423371AbXDYT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 15:57:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422747AbXDYT5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 15:57:51 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070425.124354.55506567.davem@davemloft.net> 
References: <20070425.124354.55506567.davem@davemloft.net>  <20070425041514.bb770377.akpm@linux-foundation.org> <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com> <13484.1177508312@redhat.com> 
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] AF_RXRPC socket family and AFS rewrite [try #3] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 25 Apr 2007 20:56:47 +0100
Message-ID: <32075.1177531007@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> wrote:

> Then please generate your patches against my net-2.6.21 GIT
> tree.  Most of your initial patches in the series (the SKB
> routine one for example) are already in my tree.

Do you mean your net-2.6.22 GIT tree?

Do you want me to make it available as a GIT tree for you to pull?  Or would
you prefer patches?

David
