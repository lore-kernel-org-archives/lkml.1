Return-Path: <linux-kernel-owner+w=401wt.eu-S971492AbXILSEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971492AbXILSEj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 14:04:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969349AbXILSEX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 14:04:23 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:54583 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765554AbXILSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 14:04:22 -0400
Date: Wed, 12 Sep 2007 20:04:20 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Emil Medve <Emilian.Medve@Freescale.com>
cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, i2c@lm-sensors.org,
       linux-omap-open-source@linux.omap.com
Subject: Re: [PATCH v3] Make the pr_*() family of macros in kernel.h complete
In-Reply-To: <11896151802410-git-send-email-Emilian.Medve@Freescale.com>
Message-ID: <Pine.LNX.4.64.0709122003410.22467@fbirervta.pbzchgretzou.qr>
References: <11896151802410-git-send-email-Emilian.Medve@Freescale.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sep 12 2007 11:39, Emil Medve wrote:
>
>Other/Some pr_*() macros are already defined in kernel.h, but pr_err() was defined
>multiple times in several other places

Note http://lkml.org/lkml/2007/8/4/30 .
