Return-Path: <linux-kernel-owner+w=401wt.eu-S933262AbXEEQkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262AbXEEQkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933955AbXEEQkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:40:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:52583 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933262AbXEEQkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:40:19 -0400
Message-ID: <463C625C.8040405@googlemail.com>
Date: Sat, 05 May 2007 12:54:20 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-mm1
References: <20070505014955.8f3990b5.akpm@linux-foundation.org>
In-Reply-To: <20070505014955.8f3990b5.akpm@linux-foundation.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21/2.6.21-mm1/
>
>   
Some warnings again on i386.

...

scripts/kconfig/mconf arch/i386/Kconfig
drivers/macintosh/Kconfig:116:warning: 'select' used by config symbol 
'PMAC_APM_EMU' refers to undefined symbol 'SYS_SUPPORTS_APM_EMULATION'
drivers/net/Kconfig:2336:warning: 'select' used by config symbol 
'UCC_GETH' refers to undefined symbol 'UCC_FAST'

...


Gabriel
