Return-Path: <linux-kernel-owner+w=401wt.eu-S1758654AbYFXIfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbYFXIfB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 04:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYFXIex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 04:34:53 -0400
Received: from atlanta.zankel.net ([69.61.78.146]:4248 "EHLO
	atlanta.zankel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752772AbYFXIew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 04:34:52 -0400
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Jun 2008 04:34:52 EDT
Message-ID: <4860AF80.5060809@zankel.net>
Date: Tue, 24 Jun 2008 01:25:36 -0700
From: Chris Zankel <chris@zankel.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, cooloney@kernel.org, dev-etrax@axis.com,
       dhowells@redhat.com, gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch contains the following cleanups for the asm/ptrace.h 
> userspace headers:
> - xtensa: cosmetical change to remove empty
>             #ifndef __ASSEMBLY__ #else #endif
>           from the userspace headers
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

The Xtensa part also looks ok.

Acked-by: Chris Zankel <chris@zankel.net>


Regards,
-Chris
