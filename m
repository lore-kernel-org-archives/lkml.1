Return-Path: <linux-kernel-owner+w=401wt.eu-S1755888AbZGNRZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888AbZGNRZ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755828AbZGNRZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:25:29 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755298AbZGNRZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:25:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4A5CB414.5000001@nokia.com>
References: <4A5CB414.5000001@nokia.com> <1247561220.2473.0.camel@ht.satnam> <20090709094430.23882.46013.stgit@warthog.procyon.org.uk> <5554.1247588246@redhat.com>
To: Artem.Bityutskiy@nokia.com
Cc: dhowells@redhat.com, Jaswinder Singh Rajput <jaswinder@kernel.org>,
       "torvalds@osdl.org" <torvalds@osdl.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] AFS: Fix compilation warning
Date: Tue, 14 Jul 2009 18:22:58 +0100
Message-ID: <6223.1247592178@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem Bityutskiy <Artem.Bityutskiy@nokia.com> wrote:

> FWIW, if you want to apply this patch, then you probably
> should first revert my patch, or make this patch undo my
> "unitinialized_var" changes. And probably this stuff is
> anyway not 2.6.31 material, because the warning is fixed
> anyway :-) Anyway, not my area :-)

Thanks for testing it.  I'll keep it on ice till 2.6.31.

David
