Return-Path: <linux-kernel-owner+w=401wt.eu-S1753719AbYACXtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719AbYACXtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 18:49:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYACXtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 18:49:31 -0500
Received: from rgminet01.oracle.com ([148.87.113.118]:32756 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbYACXta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 18:49:30 -0500
Date: Thu, 3 Jan 2008 15:47:40 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
Cc: linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [PATCH] This patch to printk.c fixes a few errors reported by
 checkpatch.pl
Message-Id: <20080103154740.9a815703.randy.dunlap@oracle.com>
In-Reply-To: <20080104001446.66f0c110@paolo-desktop>
References: <20080104001446.66f0c110@paolo-desktop>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jan 2008 00:14:46 +0100 Paolo Ciarrocchi wrote:

> This patch to printk.c fixes a few errors reported by checkpatch.pl
> 
> Before:
> total: 18 errors, 17 warnings, 1306 lines checked
> 
> After:
> total: 1 errors, 17 warnings, 1305 lines checked
> 
> 
> Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
> ---
> 
> Adrian, I'm sending this patch to you because according to git shortlog -e
> you are the most active modifier of this file.
> 
> 
>  kernel/printk.c |   25 ++++++++++++-------------
>  1 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 89011bf..00f784f 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c

Hi,

Please read Andrew's "The Perfect Patch," especially the section
about Subject: lines.

http://www.zip.com.au/~akpm/linux/patches/stuff/tpp.txt

---
~Randy
desserts:  http://www.xenotime.net/linux/recipes/
