Return-Path: <linux-kernel-owner+w=401wt.eu-S1764228AbZDANkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764228AbZDANkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 09:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754853AbZDANkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 09:40:09 -0400
Received: from relay.atmel.no ([80.232.32.139]:50359 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754764AbZDANkH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 09:40:07 -0400
Date: Wed, 1 Apr 2009 15:39:57 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
Cc: linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       maciej.sosnowski@intel.com
Subject: Re: [PATCH v2 1/1] dw_dmac: add cyclic API to DW DMA driver
Message-ID: <20090401153957.6982f050@hskinnemoen-d830>
In-Reply-To: <1238592485-14369-1-git-send-email-hans-christian.egtvedt@atmel.com>
References: <20090401111116.7c604530@hcegtvedt>
	<1238592485-14369-1-git-send-email-hans-christian.egtvedt@atmel.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian Egtvedt wrote:
> +/**
> + * dw_dma_cyclic_start - start the cyclic DMA transfer
> + *
> + * @chan: the DMA channel to start

Documentation/kernel-doc-nano-HOWTO.txt says:

The @argument descriptions must begin on the very next line following
this opening short function description line, with no intervening
empty comment lines.

Looks good other than that.

Haavard
