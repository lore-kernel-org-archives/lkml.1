Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbZIQVD2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbZIQVD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 17:03:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbZIQVD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 17:03:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47079 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbZIQVD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 17:03:27 -0400
Date: Thu, 17 Sep 2009 17:03:27 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       drepper@redhat.com, viro@zeniv.linux.org.uk, kyle@mcmartin.ca,
       sct@redhat.com
Subject: Re: [PATCH] implement posix O_SYNC and O_DSYNC semantics
Message-ID: <20090917210327.GE11961@bombadil.infradead.org>
References: <20090914165419.GD25549@duck.suse.cz> <20090915131252.GA13754@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090915131252.GA13754@lst.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 03:12:52PM +0200, Christoph Hellwig wrote:
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Trond Myklebust <Trond.Myklebust@netapp.com>
> 

Acked-by: Kyle McMartin <kyle@redhat.com>

Parisc bits look ok to me.
