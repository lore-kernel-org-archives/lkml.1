Return-Path: <linux-kernel-owner+w=401wt.eu-S942832AbXHMRAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942832AbXHMRAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 13:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970219AbXHMQfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:35:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3127 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031605AbXHMQe5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:34:57 -0400
Subject: Re: [PATCH] [344/2many] MAINTAINERS - NFS CLIENT
From: Joe Perches <joe@perches.com>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <1187022387.6628.16.camel@heimdal.trondhjem.org>
References: <46bffb13.g6PWKhDCxXTpAZFm%joe@perches.com>
	 <1187022387.6628.16.camel@heimdal.trondhjem.org>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 09:33:47 -0700
Message-Id: <1187022827.10249.95.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 12:26 -0400, Trond Myklebust wrote:
> I'm not planning on taking over the maintainership of nfsd or
> fs/nfsctl.c anytime soon.
> 
> However fs/lockd, include/linux/lockd/ is missing, as is
> include/linux/sunrpc and net/sunrpc/

Saved as:

NFS CLIENT
P:	Trond Myklebust
M:	trond.myklebust@fys.uio.no
L:	linux-kernel@vger.kernel.org
S:	Maintained
F:	fs/lockd/
F:	fs/nfs/
F:	fs/nfs_common/
F:	net/sunrpc/
F:	include/linux/lockd/
F:	include/linux/nfs*
F:	include/linux/nfsd/
F:	include/linux/sunrpc/


