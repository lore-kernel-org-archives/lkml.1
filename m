Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbZIVP0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbZIVP0M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 11:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756862AbZIVP0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 11:26:11 -0400
Received: from mail-px0-f199.google.com ([209.85.216.199]:62126 "EHLO
	mail-px0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbZIVP0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 11:26:10 -0400
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Sandeep Paulraj <s-paulraj@ti.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: includecheck fix: mach-davinci, board-dm365-evm.c
References: <1253624821.3784.8.camel@ht.satnam>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Tue, 22 Sep 2009 08:26:12 -0700
In-Reply-To: <1253624821.3784.8.camel@ht.satnam> (Jaswinder Singh Rajput's message of "Tue\, 22 Sep 2009 18\:37\:01 +0530")
Message-ID: <87k4zrdmqz.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder Singh Rajput <jaswinder@kernel.org> writes:

> fix the following 'make includecheck' warning:
>
>   arch/arm/mach-davinci/board-dm365-evm.c: mach/common.h is included more than once.
>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

