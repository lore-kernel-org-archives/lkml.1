Return-Path: <linux-kernel-owner+w=401wt.eu-S1755792AbYL2BkG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbYL2BkG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 20:40:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751124AbYL2Bjw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 20:39:52 -0500
Received: from rcsinet13.oracle.com ([148.87.113.125]:35051 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbYL2Bjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 20:39:51 -0500
Message-ID: <49582A61.6040209@oracle.com>
Date: Sun, 28 Dec 2008 17:39:45 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: defconfigs (x86 defconfig: increase CONFIG_LOG_BUF_SHIFT)
References: <200812282126.mBSLQ48J004583@hera.kernel.org>
In-Reply-To: <200812282126.mBSLQ48J004583@hera.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.49582A63.0180:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linux Kernel Mailing List wrote:
> Author:     Ingo Molnar <mingo@elte.hu>
> 
>     x86 defconfig: increase CONFIG_LOG_BUF_SHIFT
>     
>     Impact: double the defconfig printk buffer
>     
>     Booting defconfigs produces more output than 128K so the output is
>     truncated - double it to 256K.
>     
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/configs/i386_defconfig   |    2 +-
>  arch/x86/configs/x86_64_defconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)


Would someone attempt to explain the current purpose of defconfig files,
please?

thanks,
-- 
~Randy
