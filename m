Return-Path: <linux-kernel-owner+w=401wt.eu-S937239AbXLQUOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937239AbXLQUOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:14:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933550AbXLQTxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:53:17 -0500
Received: from h155.mvista.com ([63.81.120.155]:59969 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764999AbXLQTxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:53:15 -0500
Message-ID: <4766D3BE.7070509@ru.mvista.com>
Date: Mon, 17 Dec 2007 22:53:34 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH] include/asm-mips/: Spelling fixes
References: <1197919875-5288-10-git-send-email-joe@perches.com>
In-Reply-To: <1197919875-5288-10-git-send-email-joe@perches.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>

> diff --git a/include/asm-mips/mach-wrppmc/mach-gt64120.h b/include/asm-mips/mach-wrppmc/mach-gt64120.h
> index 00d8bf6..465234a 100644
> --- a/include/asm-mips/mach-wrppmc/mach-gt64120.h
> +++ b/include/asm-mips/mach-wrppmc/mach-gt64120.h
> @@ -45,7 +45,7 @@
>  #define GT_PCI_IO_SIZE	0x02000000UL
>  
>  /*
> - * PCI interrupts will come in on either the INTA or INTD interrups lines,
> + * PCI interrupts will come in on either the INTA or INTD interrupts lines,

    "interrupt" here.

WBR, Sergei
