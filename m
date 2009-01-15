Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZAODqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZAODqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 22:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZAODqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 22:46:24 -0500
Received: from gate.crashing.org ([63.228.1.57]:58178 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754288AbZAODqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 22:46:24 -0500
Cc: Pierre Ossman <drzeus-mmc@drzeus.cx>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Xie Xiaobo <X.Xie@freescale.com>,
       Konjin Lai <Konjin.Lai@freescale.com>,
       "Joe D'Abbraccio" <Joe.D'abbraccio@freescale.com>
Message-Id: <533AEE7C-0605-43E9-BB9F-615BE6761202@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
In-Reply-To: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Date: Wed, 14 Jan 2009 21:43:50 -0600
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 14, 2009, at 1:46 PM, Anton Vorontsov wrote:

> From: Xie Xiaobo <X.Xie@freescale.com>
>
> This patch adds support for the Freescale Enhanced Secure Digital
> Host Controller Interface as found in some Freescale PowerPC
> microprocessors (e.g. MPC837x SOCs).
>
> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> Signed-off-by: Konjin Lai <Konjin.Lai@freescale.com>
> Signed-off-by: Joe D'Abbraccio <Joe.D'abbraccio@freescale.com>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
> drivers/mmc/host/Kconfig  |    9 +
> drivers/mmc/host/Makefile |    1 +
> drivers/mmc/host/esdhc.c  | 1321 ++++++++++++++++++++++++++++++++++++ 
> +++++++++
> drivers/mmc/host/esdhc.h  |  255 +++++++++
> 4 files changed, 1586 insertions(+), 0 deletions(-)
> create mode 100644 drivers/mmc/host/esdhc.c
> create mode 100644 drivers/mmc/host/esdhc.h

Want to work some device tree docs for this.

- k
