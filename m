Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbXKLPMM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbXKLPMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 10:12:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753703AbXKLPL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 10:11:56 -0500
Received: from rv-out-0910.google.com ([209.85.198.187]:54196 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753637AbXKLPLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 10:11:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RoQnCjVKscTjLrp6T+0KEKtRaxg4iIn1Ekxd1hEXUcUW6sNyV09b7XASzsUiUQoJUteca+l03X8hp0qRTk5YoK9snKiPwy46OoLiItdwg9411OR067gB8WlWyoI7jpb/FM8b6fFcFvMxtjSr6o2EB89+szxpwuuaZffv2hdH5E8=
Message-ID: <47386D2E.5090202@gmail.com>
Date: Tue, 13 Nov 2007 00:11:42 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] libata: remove unused functions
References: <20071111112956.GM21669@stusta.de>
In-Reply-To: <20071111112956.GM21669@stusta.de>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> This patch removes the following obsolete functions:
> - libata-core.c: __sata_phy_reset()
> - libata-core.c: sata_phy_reset()
> - libata-eh.c: ata_qc_timeout()
> - libata-eh.c: ata_eng_timeout()
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Queued in #tj-upstream-fixes which will be merged into 2.6.24.

Thanks.

-- 
tejun
