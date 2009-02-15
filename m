Return-Path: <linux-kernel-owner+w=401wt.eu-S1755497AbZBOUme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755497AbZBOUme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 15:42:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZBOUm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 15:42:26 -0500
Received: from xenotime.net ([72.52.64.118]:54565 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751660AbZBOUm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 15:42:26 -0500
Date: Sun, 15 Feb 2009 12:43:05 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Qinghuang Feng <qhfeng.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] : cleanup kernel-doc
Message-Id: <20090215124305.5d4feab7.rdunlap@xenotime.net>
In-Reply-To: <49902efb.0e1b6e0a.664d.ffff80b7@mx.google.com>
References: <49902efb.0e1b6e0a.664d.ffff80b7@mx.google.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Feb 2009 21:26:16 +0800 Qinghuang Feng wrote:

> Remove redundant argument comment.
> 
> Signed-off-by: Qinghuang Feng <qhfeng.kernel@gmail.com>
> ---
> diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> index 790f9d7..590e77f 100644
> --- a/kernel/sysctl.c
> +++ b/kernel/sysctl.c
> @@ -2709,7 +2709,6 @@ int proc_dointvec_userhz_jiffies(struct ctl_table *table, int write, struct file
>   * @filp: the file structure
>   * @buffer: the user buffer
>   * @lenp: the size of the user buffer
> - * @ppos: file position
>   * @ppos: the current position in the file
>   *
>   * Reads/writes up to table->maxlen/sizeof(unsigned int) integer
> 
> --

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

---
~Randy
