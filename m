Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYAXBzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYAXBzW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 20:55:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752811AbYAXBzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 20:55:08 -0500
Received: from gate.crashing.org ([63.228.1.57]:36816 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478AbYAXBzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 20:55:05 -0500
Date: Wed, 23 Jan 2008 19:51:25 -0600 (CST)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: Jochen Friedrich <jochen@scram.de>
cc: Paul Mackerras <paulus@samba.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       "Kernel, Linux" <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "Garzik, Jeff" <jgarzik@pobox.com>,
       Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH] [POWERPC] Add fixed-phy support for fs_enet
In-Reply-To: <4767E677.7010200@scram.de>
Message-ID: <Pine.LNX.4.64.0801231951150.8658@blarg.am.freescale.net>
References: <4767E677.7010200@scram.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007, Jochen Friedrich wrote:

> This patch adds support to use the fixed-link property
> of an ethernet node to fs_enet for the
> CONFIG_PPC_CPM_NEW_BINDING case.
>
> Signed-off-by: Jochen Friedrich <jochen@scram.de>
> Acked-by: Jeff Garzik <jeff@garzik.org>
> Acked-by: Vitali Bordug <vitb@kernel.crashing.org>
> ---
>  drivers/net/fs_enet/fs_enet-main.c |    9 ++++++++-
>  1 files changed, 8 insertions(+), 1 deletions(-)
>

applied.

- k
