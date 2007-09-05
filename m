Return-Path: <linux-kernel-owner+w=401wt.eu-S1756236AbXIEEcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756236AbXIEEcA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 00:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbXIEEbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 00:31:51 -0400
Received: from mxsf02.insightbb.com ([74.128.0.63]:30133 "EHLO
	mxsf02.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbXIEEbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 00:31:50 -0400
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="14171624"
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FAHHN3UZKhRO4/2dsb2JhbACBWQ
X-IronPort-AV: E=Sophos;i="4.20,209,1186372800"; 
   d="scan'208";a="122405068"
From: Dmitry Torokhov <dtor@insightbb.com>
To: Elvis Pranskevichus <el@prans.net>
Subject: Re: [PATCH] Input: i8042 - add HP Pavilion DV4270ca to the MUX blacklist
Date: Wed, 5 Sep 2007 00:31:48 -0400
User-Agent: KMail/1.9.3
Cc: LKML <linux-kernel@vger.kernel.org>
References: <11888560383968-git-send-email-el@prans.net>
In-Reply-To: <11888560383968-git-send-email-el@prans.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709050031.49040.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 September 2007 17:47, Elvis Pranskevichus wrote:
> This fixes "atkbd.c: Suprious NAK on isa0060/serio0" errors for
> HP Pavilion DV4270ca. Same reasons as for 9d9d50bb2efb50594abfc3941a5504b62c514ebd
> and 6e782584e0713ea89da151333e7fe754c8f40324.
> 
> Signed-off-by: Elvis Pranskevichus <el@prans.net>
>

Applied, thank you Elvis.
 
-- 
Dmitry
