Return-Path: <linux-kernel-owner+w=401wt.eu-S1759945AbZAREyT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759945AbZAREyT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 23:54:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751338AbZAREyH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 23:54:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:34835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754116AbZAREyG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 23:54:06 -0500
Message-ID: <4972B5E9.9020606@kernel.org>
Date: Sun, 18 Jan 2009 13:54:01 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/17] x86-64: Remove pda.h
References: <73c1f2160901160610l57e31a64j56fe9544bd2fd309@mail.gmail.com> <1232115396-26367-2-git-send-email-brgerst@gmail.com> <1232115396-26367-3-git-send-email-brgerst@gmail.com> <1232115396-26367-4-git-send-email-brgerst@gmail.com> <1232115396-26367-5-git-send-email-brgerst@gmail.com> <1232115396-26367-6-git-send-email-brgerst@gmail.com> <1232115396-26367-7-git-send-email-brgerst@gmail.com> <1232115396-26367-8-git-send-email-brgerst@gmail.com> <1232115396-26367-9-git-send-email-brgerst@gmail.com> <1232115396-26367-10-git-send-email-brgerst@gmail.com> <1232115396-26367-11-git-send-email-brgerst@gmail.com> <1232115396-26367-12-git-send-email-brgerst@gmail.com> <1232115396-26367-13-git-send-email-brgerst@gmail.com> <1232115396-26367-14-git-send-email-brgerst@gmail.com> <1232115396-26367-15-git-send-email-brgerst@gmail.com> <1232115396-26367-16-git-send-email-brgerst@gmail.com> <1232115396-26367-17-git-send-email-brgerst@gmail.com>
In-Reply-To: <1232115396-26367-17-git-send-email-brgerst@gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 04:54:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brian Gerst wrote:
> Signed-off-by: Brian Gerst <brgerst@gmail.com>
> ---
>  arch/x86/include/asm/pda.h        |   39 -------------------------------------
>  arch/x86/include/asm/pgtable_64.h |    1 -
>  arch/x86/include/asm/smp.h        |    1 -
>  arch/x86/kernel/cpu/common.c      |    1 -
>  arch/x86/kernel/process_64.c      |    1 -
>  arch/x86/kernel/traps.c           |    1 -
>  6 files changed, 0 insertions(+), 44 deletions(-)
>  delete mode 100644 arch/x86/include/asm/pda.h

Ah.. the sweet smell of death.  Nice.  :-)

-- 
tejun
