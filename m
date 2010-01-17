Return-Path: <linux-kernel-owner+w=401wt.eu-S1754919Ab0AQVTx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919Ab0AQVTx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:19:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754768Ab0AQVTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:19:52 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52983 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753463Ab0AQVTv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:19:51 -0500
Date: Sun, 17 Jan 2010 22:19:50 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       WANG Cong <amwang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: typo at ksysfs.c s/boo/boot/
In-Reply-To: <1263762867-9090-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1001172219430.30977@pobox.suse.cz>
References: <1263762867-9090-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  kernel/ksysfs.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/ksysfs.c b/kernel/ksysfs.c
> index 3feaf5a..ac08efc 100644
> --- a/kernel/ksysfs.c
> +++ b/kernel/ksysfs.c
> @@ -33,7 +33,7 @@ static ssize_t uevent_seqnum_show(struct kobject *kobj,
>  }
>  KERNEL_ATTR_RO(uevent_seqnum);
>  
> -/* uevent helper program, used during early boo */
> +/* uevent helper program, used during early boot */
>  static ssize_t uevent_helper_show(struct kobject *kobj,
>  				  struct kobj_attribute *attr, char *buf)
>  {

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
