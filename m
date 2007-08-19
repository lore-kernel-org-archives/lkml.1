Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXHSXSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXHSXSy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 19:18:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbXHSXSp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 19:18:45 -0400
Received: from rex.snapgear.com ([203.143.235.140]:49568 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751705AbXHSXSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 19:18:44 -0400
Message-ID: <46C8CFCF.9000606@snapgear.com>
Date: Mon, 20 Aug 2007 09:18:39 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
       Bryan Wu <bryan.wu@analog.com>,
       Yoshinori Sato <ysato@users.sourceforge.jp>,
       Greg Ungerer <gerg@uclinux.org>, Paul Mundt <lethal@linux-sh.org>,
       Miles Bader <uclinux-v850@lsi.nec.co.jp>
Subject: Re: [PATCH trivial] include/asm-*/system.h: remove unused set_rmb(),
 set_wmb() macros
References: <tkrat.eb667dbcda37eb9d@s5r6.in-berlin.de>
In-Reply-To: <tkrat.eb667dbcda37eb9d@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Stefan Richter wrote:
> These don't appear anywhere else in the kernel anymore.
> 
> Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Cc: Bryan Wu <bryan.wu@analog.com>
> Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
> Cc: Greg Ungerer <gerg@uclinux.org>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
> ---
>  include/asm-blackfin/system.h  |    4 +---
>  include/asm-h8300/system.h     |    3 +--
>  include/asm-m68knommu/system.h |    3 +--
>  include/asm-sh64/system.h      |    3 +--
>  include/asm-v850/system.h      |    3 +--
>  5 files changed, 5 insertions(+), 11 deletions(-)
> 
> Index: linux/include/asm-blackfin/system.h
> Index: linux/include/asm-m68knommu/system.h
> ===================================================================
> --- linux.orig/include/asm-m68knommu/system.h
> +++ linux/include/asm-m68knommu/system.h

Acked-by: Greg Ungerer <gerg@uclinux.org>


------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
