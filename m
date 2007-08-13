Return-Path: <linux-kernel-owner+w=401wt.eu-S935171AbXHMMak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935171AbXHMMak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939621AbXHMGxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:53:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34260 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939610AbXHMGxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:53:24 -0400
Message-ID: <46BFFFDC.1040406@redhat.com>
Date: Mon, 13 Aug 2007 07:53:16 +0100
From: Patrick Caulfield <pcaulfie@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: joe@perches.com
CC: torvalds@linux-foundation.org, teigland@redhat.com,
       linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [156/2many] MAINTAINERS - DISTRIBUTED LOCK MANAGER
References: <46bff98d.YdH+q2D3/NHHu3IX%joe@perches.com>
In-Reply-To: <46bff98d.YdH+q2D3/NHHu3IX%joe@perches.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 0b054e1..bd0fa0e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1526,6 +1526,8 @@ W:	http://sources.redhat.com/cluster/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
>  T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
>  S:	Supported
> +F:	Documentation/filesystems/dlmfs.txt
> +F:	fs/dlm/
>  

NACK - that dlmfs.txt file refers to the DLM in ocfs2, not to the DLM in fs/dlm


-- 
Patrick

