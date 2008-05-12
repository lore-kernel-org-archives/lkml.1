Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYELOkA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYELOkA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 10:40:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYELOjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 10:39:52 -0400
Received: from h155.mvista.com ([63.81.120.155]:20800 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751852AbYELOjv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 10:39:51 -0400
Message-ID: <48285699.5060700@ru.mvista.com>
Date: Mon, 12 May 2008 18:39:21 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: abhiruchi.g@vaultinfo.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>,
       kernel-testers@vger.kernel.org
Subject: Re: WARNING: arch/mips/au1000/common/built-in.o(.text+0x15c0): Section
 mismatch: reference to .init.data: (between 'au1xxx_platform_init' and '__fixup_bigphys_addr')
References: <54350.192.168.1.71.1210568848.webmail@192.168.1.71>
In-Reply-To: <54350.192.168.1.71.1210568848.webmail@192.168.1.71>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

abhiruchi.g@vaultinfo.com wrote:

> Hi all,
>   I am trying to configure the kernel for mips(DB1200 bosrd).I am getting this warning.
> how to remove this warning?

> WARNING: arch/mips/au1000/common/built-in.o(.text+0x15c0): Section mismatch: reference to .init.data: (between 'au1xxx_platform_init' and '__fixup_bigphys_addr')
> WARNING: arch/mips/au1000/common/built-in.o(.text+0x15c4): Section mismatch: reference to .init.data: (between 'au1xxx_platform_init' and '__fixup_bigphys_addr

    Which kernel version are you building? I'mnot seeing anything alike.

WBR, Sergei
