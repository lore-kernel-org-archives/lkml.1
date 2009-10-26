Return-Path: <linux-kernel-owner+w=401wt.eu-S1754432AbZJZBBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbZJZBBI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 21:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbZJZBBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 21:01:07 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:36598 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559AbZJZBBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 21:01:06 -0400
Date: Mon, 26 Oct 2009 10:01:06 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sh: Build fix: define more __movmem* symbols
Message-ID: <20091026010106.GC6108@linux-sh.org>
References: <1256212717-14858-1-git-send-email-lkundrak@v3.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256212717-14858-1-git-send-email-lkundrak@v3.sk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 01:58:37PM +0200, Lubomir Rintel wrote:
> ERROR: "__movmemSI12" [net/unix/unix.ko] undefined!
> ERROR: "__movmemSI52" [net/ipv6/sit.ko] undefined!
> ERROR: "__movmemSI24" [net/ipv6/ipv6.ko] undefined!
> ERROR: "__movmemSI60" [net/ipv6/ipv6.ko] undefined!
> ERROR: "__movmemSI16" [net/ipv6/ipv6.ko] undefined!
> ERROR: "__movmemSI20" [net/ipv6/ipv6.ko] undefined!
> ERROR: "__movmemSI32" [net/ipv6/ipv6.ko] undefined!
> ---
>  arch/sh/kernel/sh_ksyms_32.c |   14 ++++++++++++++
>  1 files changed, 14 insertions(+), 0 deletions(-)
> 
Applied to the 2.6.32 queue, thanks.
