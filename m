Return-Path: <linux-kernel-owner+w=401wt.eu-S1758764AbYGRVk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764AbYGRVk0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 17:40:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754521AbYGRVkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 17:40:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45990 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbYGRVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 17:40:14 -0400
Message-ID: <48810DA8.7080301@zytor.com>
Date: Fri, 18 Jul 2008 14:39:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: reduce forbid_dac's visibility
References: <4880AC40.76E4.0078.0@novell.com>
In-Reply-To: <4880AC40.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> It's not used anywhere outside its declaring file.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> 
> ---
>  arch/x86/kernel/pci-dma.c     |    3 +--
>  include/asm-x86/dma-mapping.h |    1 -
>  2 files changed, 1 insertion(+), 3 deletions(-)

Manually applied to x86/cleanups, thanks.

	-hpa
