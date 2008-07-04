Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYGDTLG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYGDTLG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 15:11:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbYGDTKx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 15:10:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42445 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbYGDTKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 15:10:52 -0400
Date: Fri, 4 Jul 2008 12:09:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Richter <robert.richter@amd.com>
Cc: oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>, Philippe Elie <phil.el@wanadoo.fr>,
       John Levon <levon@movementarian.org>,
       Maynard Johnson <maynardj@us.ibm.com>,
       Richard Purdie <rpurdie@openedhand.com>,
       Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>,
       Jason Yeh <jason.yeh@amd.com>
Subject: Re: [PATCH] OProfile kernel maintainership changes
Message-Id: <20080704120942.ed671ce2.akpm@linux-foundation.org>
In-Reply-To: <1215197619-28982-1-git-send-email-robert.richter@amd.com>
References: <1215197619-28982-1-git-send-email-robert.richter@amd.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jul 2008 20:53:39 +0200 Robert Richter <robert.richter@amd.com> wrote:

> Cc: Philippe Elie <phil.el@wanadoo.fr>
> Cc: John Levon <levon@movementarian.org>
> Cc: Maynard Johnson <maynardj@us.ibm.com>
> Cc: Richard Purdie <rpurdie@openedhand.com>
> Cc: Daniel Hansel <daniel.hansel@linux.vnet.ibm.com>
> Cc: Jason Yeh <jason.yeh@amd.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  MAINTAINERS |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e6c06fa..85a7e4a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3080,8 +3080,8 @@ L:	linux-scsi@vger.kernel.org
>  S:	Maintained
>  
>  OPROFILE
> -P:	Philippe Elie
> -M:	phil.el@wanadoo.fr
> +P:	Robert Richter
> +M:	robert.richter@amd.com
>  L:	oprofile-list@lists.sf.net
>  S:	Maintained

Well that's interesting - please tell us more?

Will you also have a role in oprofile userspace maintenance?
