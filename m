Return-Path: <linux-kernel-owner+w=401wt.eu-S1757056AbZFLPnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757056AbZFLPnX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 11:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZFLPnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 11:43:17 -0400
Received: from relay.atmel.no ([80.232.32.139]:55343 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbZFLPnR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 11:43:17 -0400
Date: Fri, 12 Jun 2009 17:42:59 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: pierre@ossman.eu, linux-arm-kernel@lists.arm.linux.org.uk,
       poorarm@shoreis.com, linux-kernel@vger.kernel.org, avictor.za@gmail.com,
       nicolas.ferre@atmel.com
Subject: Re: [PATCH 1/2] atmel-mci: Integrate AT91 specific definition in
 header file
Message-ID: <20090612174259.2162cbac@hskinnemoen-d830>
In-Reply-To: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
References: <1244822310-11562-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Ferre wrote:
> The MCI IP is shared among AVR32 and AT91 SOCs.
> AT91 has specific bit definitions in the user interface of MCI SD/MMC IP.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

I think some of these bits are valid on AVR32 as well.

Haavard
