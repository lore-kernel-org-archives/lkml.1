Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0CKTVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 14:21:42 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755385Ab0CKTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 14:21:41 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4B993229.7090302@xenotime.net>
References: <4B993229.7090302@xenotime.net> <20100311172055.7328.51353.stgit@warthog.procyon.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: dhowells@redhat.com, torvalds@osdl.org, akpm@linux-foundation.org,
       sgruszka@redhat.com, davem@davemloft.net, linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Document Linux's circular buffering capabilities
Date: Thu, 11 Mar 2010 19:20:38 +0000
Message-ID: <10220.1268335238@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@xenotime.net> wrote:

> Do the "[1]" here and in the previous section refer to note [1] below?
> If so, then the CIRC_CNT*() paragraphs below could use "[2]" for consistency.

Good point.

David
