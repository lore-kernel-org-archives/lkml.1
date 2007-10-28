Return-Path: <linux-kernel-owner+w=401wt.eu-S1752043AbXJ1FDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752043AbXJ1FDc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 01:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750809AbXJ1FDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 01:03:24 -0400
Received: from mxsf07.insightbb.com ([74.128.0.77]:20785 "EHLO
	mxsf07.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbXJ1FDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 01:03:23 -0400
X-IronPort-AV: E=Sophos;i="4.21,338,1188792000"; 
   d="scan'208";a="112263530"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJa1I0dKjlCP/2dsb2JhbACBWg
X-IronPort-AV: E=Sophos;i="4.21,338,1188792000"; 
   d="scan'208";a="89528779"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: [2.6 patch] input/serio/hp_sdc.c section fix
Date: Sun, 28 Oct 2007 01:03:20 -0400
User-Agent: KMail/1.9.3
Cc: linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20071024162640.GO30533@stusta.de>
In-Reply-To: <20071024162640.GO30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710280103.21192.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 24 October 2007 12:26, Adrian Bunk wrote:
> hp_sdc_exit() mustn't be __exit since it's called from the
> __init hp_sdc_register().
> 

Applied, thank you Adrian.

-- 
Dmitry
