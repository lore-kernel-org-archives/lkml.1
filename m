Return-Path: <linux-kernel-owner+w=401wt.eu-S1757476AbXHRRBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476AbXHRRBB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 13:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751484AbXHRRAv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 13:00:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4882 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750805AbXHRRAu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 13:00:50 -0400
Subject: Re: [PATCH 2/2] MAINTAINERS
From: Joe Perches <joe@perches.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070818150020.GB31228@fieldses.org>
References: <1187420935.4200.16.camel@localhost>
	 <20070818150020.GB31228@fieldses.org>
Content-Type: text/plain
Date: Sat, 18 Aug 2007 10:00:42 -0700
Message-Id: <1187456442.4200.26.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-08-18 at 11:00 -0400, J. Bruce Fields wrote:
> Also, some paths that are shared with the client:
> +F:	fs/lockd/
> +F:	fs/nfs_common/
> +F:	net/sunrpc/
> +F:	include/linux/lockd/
> +F:	include/linux/sunrpc/

This is what I have now:

KERNEL NFSD
P:	J. Bruce Fields
M:	bfields@fieldses.org
P:	Neil Brown
M:	neilb@suse.de
L:	nfs@lists.sourceforge.net
W:	http://nfs.sourceforge.net/
S:	Supported
F:	fs/nfsd/
F:	include/linux/nfsd/
F:	fs/lockd/
F:	fs/nfs_common/
F:	net/sunrpc/
F:	include/linux/lockd/
F:	include/linux/sunrpc/


