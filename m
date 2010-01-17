Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995Ab0AQVmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995Ab0AQVmV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 16:42:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754815Ab0AQVmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 16:42:20 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53358 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab0AQVmT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 16:42:19 -0500
Date: Sun, 17 Jan 2010 22:42:18 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-pm@vger.kernel.org
Subject: Re: [PATCH] trivial: fix typo s/leve/level/ in pm-runtime doc
In-Reply-To: <1263763348-9531-1-git-send-email-cascardo@holoscopio.com>
Message-ID: <alpine.LNX.2.00.1001172242050.30977@pobox.suse.cz>
References: <1263763348-9531-1-git-send-email-cascardo@holoscopio.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Jan 2010, Thadeu Lima de Souza Cascardo wrote:

> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
> ---
>  Documentation/power/runtime_pm.txt |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/power/runtime_pm.txt b/Documentation/power/runtime_pm.txt
> index 356fd86..8602e15 100644
> --- a/Documentation/power/runtime_pm.txt
> +++ b/Documentation/power/runtime_pm.txt
> @@ -250,7 +250,7 @@ drivers/base/power/runtime.c and include/linux/pm_runtime.h:
>        to suspend the device again in future
>  
>    int pm_runtime_resume(struct device *dev);
> -    - execute the subsystem-leve resume callback for the device; returns 0 on
> +    - execute the subsystem-level resume callback for the device; returns 0 on
>        success, 1 if the device's run-time PM status was already 'active' or
>        error code on failure, where -EAGAIN means it may be safe to attempt to
>        resume the device again in future, but 'power.runtime_error' should be

Queued.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
