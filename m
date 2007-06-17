Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXFQRsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXFQRsS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 13:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755330AbXFQRsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 13:48:03 -0400
Received: from ns2.suse.de ([195.135.220.15]:57386 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbXFQRsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 13:48:01 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, torvalds@linux-foundation.org,
       trond.myklebust@fys.uio.no, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] NFS: Make NFS root work again
References: <20070607164003.24322.51086.stgit@warthog.cambridge.redhat.com>
	<20070616091514.8e5dc1d3.akpm@linux-foundation.org>
From: Andi Kleen <andi@firstfloor.org>
Date: 17 Jun 2007 20:44:01 +0200
In-Reply-To: <20070616091514.8e5dc1d3.akpm@linux-foundation.org>
Message-ID: <p73zm2yqv4e.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> 
> What is not working, and how does this patch fix it?

FWIW i use nfs root regularly for testing kernels and it works
for me.

-Andi
