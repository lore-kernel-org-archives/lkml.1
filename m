Return-Path: <linux-kernel-owner+w=401wt.eu-S1765875AbZDCNyA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765875AbZDCNyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 09:54:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765269AbZDCNxp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 09:53:45 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54100 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765282AbZDCNxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 09:53:44 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090403135007.GB31907@infradead.org>
References: <20090403135007.GB31907@infradead.org> <20090403094138.9510.80681.stgit@warthog.procyon.org.uk> <20090403094143.9510.80474.stgit@warthog.procyon.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: dhowells@redhat.com, nickpiggin@yahoo.com.au, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/4] CacheFiles: Revert the addition of write_one_page()
Date: Fri, 03 Apr 2009 14:53:29 +0100
Message-ID: <10983.1238766809@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig <hch@infradead.org> wrote:

> Note that in the patch series going into mainline eventually this should
> not be a separate patch but the new ops should never be introduced.

Yes, probably, but this makes it easier for people to see what I'm proposing
to change.

David
