Return-Path: <linux-kernel-owner+w=401wt.eu-S1761835AbZEMWKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761835AbZEMWKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 18:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbZEMWK2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 18:10:28 -0400
Received: from gate.crashing.org ([63.228.1.57]:40368 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759409AbZEMWK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 18:10:27 -0400
Cc: akpm@linux-foundation.org, davem@davemloft.net,
       mporter@kernel.crashing.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, netdev@vger.kernel.org
Message-Id: <CE237554-D711-40AB-8446-6F3398667ED7@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Li Yang <leoli@freescale.com>
In-Reply-To: <1242117363-14949-2-git-send-email-leoli@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH 2/6] powerpc/fsl_rio: use LAW address from device tree
Date: Wed, 13 May 2009 17:08:04 -0500
References: <1242117363-14949-1-git-send-email-leoli@freescale.com> <1242117363-14949-2-git-send-email-leoli@freescale.com>
X-Mailer: Apple Mail (2.930.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 12, 2009, at 3:35 AM, Li Yang wrote:

> Instead of fixed address in old code.
>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
> arch/powerpc/sysdev/fsl_rio.c |   12 +++++++-----
> 1 files changed, 7 insertions(+), 5 deletions(-)

applied to next

- k
