Return-Path: <linux-kernel-owner+w=401wt.eu-S1755427AbYJOVY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbYJOVY2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 17:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753676AbYJOVYU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 17:24:20 -0400
Received: from gate.crashing.org ([63.228.1.57]:58901 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626AbYJOVYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 17:24:19 -0400
Cc: linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
       dbrownell@users.sourceforge.net, akpm@linux-foundation.org
Message-Id: <764B32F3-E12E-4649-A2BB-3F94044D371F@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1219294018-12557-7-git-send-email-galak@kernel.crashing.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH 6/9] mpc52xx_psc_spi: remove code associated with !CONFIG_PPC_MERGE
Date: Wed, 15 Oct 2008 16:23:33 -0500
References: <1219294018-12557-1-git-send-email-galak@kernel.crashing.org> <1219294018-12557-2-git-send-email-galak@kernel.crashing.org> <1219294018-12557-3-git-send-email-galak@kernel.crashing.org> <1219294018-12557-4-git-send-email-galak@kernel.crashing.org> <1219294018-12557-5-git-send-email-galak@kernel.crashing.org> <1219294018-12557-6-git-send-email-galak@kernel.crashing.org> <1219294018-12557-7-git-send-email-galak@kernel.crashing.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 20, 2008, at 11:46 PM, Kumar Gala wrote:

> Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore
> remove the dead code associated with !CONFIG_PPC_MERGE.
>
> Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> drivers/spi/mpc52xx_psc_spi.c |   55  
> -----------------------------------------
> 1 files changed, 0 insertions(+), 55 deletions(-)

Any update on acceptance of this patch?

- k
