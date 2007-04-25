Return-Path: <linux-kernel-owner+w=401wt.eu-S1751672AbXDYNiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672AbXDYNiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 09:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161126AbXDYNix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 09:38:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52163 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672AbXDYNiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 09:38:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070425041514.bb770377.akpm@linux-foundation.org> 
References: <20070425041514.bb770377.akpm@linux-foundation.org>  <20070425105036.10872.48596.stgit@warthog.cambridge.redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 00/16] AF_RXRPC socket family and AFS rewrite [try #3] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 25 Apr 2007 14:38:32 +0100
Message-ID: <13484.1177508312@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> I'm ducking all feature and cleanup patches now, and probably shall
> continue to do so for some weeks.  The priority (which I believe to be
> increasingly urgent) is to fix the 2.6.21 regressions and to stabilise
> the things which we presently have queued for 2.6.22.  Not to
> mention the 1000ish unaddressed bug reports in bugzilla and elsewhere.

Fair enough.  I think the idea is for them (or at least some of them) to go
through one of DaveM's net git trees anyway.

David
