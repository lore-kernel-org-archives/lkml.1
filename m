Return-Path: <linux-kernel-owner+w=401wt.eu-S933025AbXGMHFY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbXGMHFY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:05:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760737AbXGMHE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:04:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:35413 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760955AbXGMHE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:04:58 -0400
Date: Fri, 13 Jul 2007 00:04:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] h8300 entry.S update
Message-Id: <20070713000444.4e2facb5.akpm@linux-foundation.org>
In-Reply-To: <m2k5t4u6zv.wl%ysato@users.sourceforge.jp>
References: <m2k5t4u6zv.wl%ysato@users.sourceforge.jp>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jul 2007 15:56:20 +0900 Yoshinori Sato <ysato@users.sourceforge.jp> wrote:

> Subject: [PATCH] h8300 entry.S update
> Date: Fri, 13 Jul 2007 15:56:20 +0900
> Organization: SIOS Technology, Inc.
> User-Agent: Wanderlust/2.15.5 (Almost Unreal) SEMI/1.14.6 (Maruoka)
>  FLIM/1.14.8 (Shijō) APEL/10.6 Emacs/22.0.93
>  (i486-pc-linux-gnu) MULE/5.0 (SAKAKI)
> 
> Signed-off-by: Yoshinori Sato <ysato@users.sourceforge.jp>
> 
> diff --git a/arch/h8300/kernel/Makefile b/arch/h8300/kernel/Makefile

hm, we're missing any description of what this change actually does?
