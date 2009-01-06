Return-Path: <linux-kernel-owner+w=401wt.eu-S1753271AbZAFT43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbZAFT43 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 14:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751567AbZAFT4W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 14:56:22 -0500
Received: from mx2.redhat.com ([66.187.237.31]:57469 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbZAFT4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 14:56:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090106194101.GB5901@fieldses.org>
References: <20090106194101.GB5901@fieldses.org> <806.1231174132@redhat.com> <20090105171937.4463.98583.stgit@warthog.procyon.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: dhowells@redhat.com, hch@lst.de, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] CRED: Fix NFSD regression
Date: Tue, 06 Jan 2009 19:56:11 +0000
Message-ID: <28704.1231271771@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

J. Bruce Fields <bfields@fieldses.org> wrote:

> OK, I've tested this and applied it for 2.6.29.
> 
> Though it only actually fixes the regression if your other patch ("CRED:
> Fix regression in cap_capable() as shown up by sys_faccessat() [ver #2")
> is also applied.  I'd like to send in my pull request today, but I
> usually try not to send a pull request whose tip doesn't pass at least
> my basic regression tests....  And that other patch is outside my
> baliwick.    Can someone else handle it?

Well, if you're willing to supply an Acked-by or Tested-by for one or both
patches I can pass them on to James or Linus.

David
