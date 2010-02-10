Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239Ab0BJItZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 03:49:25 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:39642 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0BJItY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 03:49:24 -0500
Date: Wed, 10 Feb 2010 17:49:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v2 -mm 10/14] sh: use include/linux/pci-dma.h
Message-ID: <20100210084919.GA907@linux-sh.org>
References: <1265765687-14121-1-git-send-email-fujita.tomonori@lab.ntt.co.jp> <1265765687-14121-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265765687-14121-11-git-send-email-fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 10:34:43AM +0900, FUJITA Tomonori wrote:
> Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> Cc: Paul Mundt <lethal@linux-sh.org>
> ---
>  arch/sh/Kconfig           |    3 +++
>  arch/sh/include/asm/pci.h |   19 +------------------
>  2 files changed, 4 insertions(+), 18 deletions(-)
> 
Looks ok to me.

Acked-by: Paul Mundt <lethal@linux-sh.org>
