Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbYHCCYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbYHCCYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 22:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750935AbYHCCYA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 22:24:00 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:41567 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750819AbYHCCX7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 22:23:59 -0400
Date: Sun, 3 Aug 2008 11:23:14 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] sh/boards/Makefile typo fix
Message-ID: <20080803022313.GA15509@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080802165344.GP19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080802165344.GP19682@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 07:53:44PM +0300, Adrian Bunk wrote:
> The following build error was caused by an obvious typo:
> 
> <--  snip  -->
> 
> ...
>   LD      arch/sh/mm/built-in.o
> make[2]: *** No rule to make target `arch/sh/boards/board-shmin..o', needed by `arch/sh/boards/built-in.o'.  Stop.
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
Applied, thanks.
