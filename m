Return-Path: <linux-kernel-owner+w=401wt.eu-S1762884AbXHQPnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762884AbXHQPnY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 11:43:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbXHQPnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 11:43:15 -0400
Received: from h155.mvista.com ([63.81.120.155]:49938 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755076AbXHQPnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 11:43:14 -0400
Message-ID: <46C5C2A1.3020701@ru.mvista.com>
Date: Fri, 17 Aug 2007 19:45:37 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, jgarzik@pobox.com, akpm@linux-foundation.org
Subject: Re: [PATCH] [428/2many] MAINTAINERS - SERIAL ATA (SATA) SUBSYSTEM:
References: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
In-Reply-To: <46bffbb6.4FinvGMu+SlIxG24%joe@perches.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

joe@perches.com wrote:

> Add file pattern to MAINTAINER entry

> Signed-off-by: Joe Perches <joe@perches.com>

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 04c969c..016cd0c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4077,6 +4077,7 @@ M:	jgarzik@pobox.com
>  L:	linux-ide@vger.kernel.org
>  T:	git kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>  S:	Supported
> +F:	drivers/ata/sata_*

    The libata core doesn't match this pattern, ain't a a vital part of both 
SAT and PATA drivers?

MBR, Sergei
