Return-Path: <linux-kernel-owner+w=401wt.eu-S1755097AbXHRPAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097AbXHRPAa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 11:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753169AbXHRPAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 11:00:23 -0400
Received: from mail.fieldses.org ([66.93.2.214]:57369 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752928AbXHRPAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 11:00:22 -0400
Date: Sat, 18 Aug 2007 11:00:20 -0400
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] MAINTAINERS
Message-ID: <20070818150020.GB31228@fieldses.org>
References: <1187420935.4200.16.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1187420935.4200.16.camel@localhost>
User-Agent: Mutt/1.5.16 (2007-06-11)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2007 at 12:08:54AM -0700, Joe Perches wrote:
>  KERNEL NFSD
>  P:	J. Bruce Fields
>  M:	bfields@fieldses.org
>  P:	Neil Brown
>  M:	neilb@suse.de
>  L:	nfs@lists.sourceforge.net
>  W:	http://nfs.sourceforge.net/
>  S:	Supported
> +F:	fs/nfsd/
> +F:	include/linux/nfsd/

Also, some paths that are shared with the client:

+F:	fs/lockd/
+F:	fs/nfs_common/
+F:	net/sunrpc/
+F:	include/linux/lockd/
+F:	include/linux/sunrpc/

--b.
