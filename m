Return-Path: <linux-kernel-owner+w=401wt.eu-S965568AbXHMNRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568AbXHMNRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970665AbXHMJAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 05:00:24 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S970866AbXHMJAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 05:00:19 -0400
Subject: Re: [PATCH] [208/2many] MAINTAINERS - GFS2 FILE SYSTEM
From: Steven Whitehouse <swhiteho@redhat.com>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, akpm@linux-foundation.org
In-Reply-To: <46bffa01.umS2rSd+AoRJwoFx%joe@perches.com>
References: <46bffa01.umS2rSd+AoRJwoFx%joe@perches.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 13 Aug 2007 09:54:18 +0100
Message-Id: <1186995258.8765.795.camel@quoit>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, 2007-08-12 at 23:28 -0700, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d8063ee..b4183e7 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1992,6 +1992,9 @@ W:	http://sources.redhat.com/cluster/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
>  T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
>  S:	Supported
> +F:	/Documentation/filesystems/gfs2.txt
> +F:	fs/gfs2/
> +F:	include/linux/gfs2_ondisk.h
This is missing:
   F:     include/linux/lm_interface.h

Steve.

>  
>  GIGASET ISDN DRIVERS
>  P:	Hansjoerg Lipp

