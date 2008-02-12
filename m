Return-Path: <linux-kernel-owner+w=401wt.eu-S1760236AbYBLHyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760236AbYBLHyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 02:54:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbYBLHyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 02:54:46 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53262 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756704AbYBLHyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 02:54:46 -0500
Date: Mon, 11 Feb 2008 23:52:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>, viro@zeniv.linux.org.uk,
       Neil Brown <neilb@suse.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/4] kernel-doc: fix fs/pipe.c notation
Message-Id: <20080211235229.3b36ac56.akpm@linux-foundation.org>
In-Reply-To: <20080211172753.3990e7bb.randy.dunlap@oracle.com>
References: <20080211172753.3990e7bb.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Feb 2008 17:27:53 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix several kernel-doc notation errors in fs/pipe.c.
> 

Thanks, Randy.  I think I'll slip these four patches into mainline while
they don't conflict with anyone else's stuff.  (Well, apart from git-x86,
but that's usual :))

