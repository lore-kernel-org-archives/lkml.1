Return-Path: <linux-kernel-owner+w=401wt.eu-S1757702AbXKTFxY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702AbXKTFxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 00:53:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754068AbXKTFxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 00:53:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:50323 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbXKTFxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 00:53:16 -0500
Date: Mon, 19 Nov 2007 23:51:46 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] PPC: Fix potential NULL dereference
In-Reply-To: <20071115184705.GA7273@cvg>
Message-ID: <Pine.LNX.4.64.0711192351010.1217@blarg.am.freescale.net>
References: <20071115184705.GA7273@cvg>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2007, Cyrill Gorcunov wrote:

> This patch does fix potential NULL pointer dereference
> that could take place inside of strcmp() if
> of_get_property() call failed.
>
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
>
>  arch/powerpc/platforms/83xx/usb.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>

CC the linuxppc-dev@ozlabs.org list in the future.

applied.

- k
