Return-Path: <linux-kernel-owner+w=401wt.eu-S1752223AbZKCLbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbZKCLbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 06:31:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751336AbZKCLbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 06:31:33 -0500
Received: from smtp.nokia.com ([192.100.122.233]:52131 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZKCLbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 06:31:32 -0500
Date: Tue, 3 Nov 2009 13:29:49 +0200 (EET)
From: Ilkka Koskinen <ikoskine@nokia.com>
X-X-Sender: ikoskine@tumpelo.ntc.nokia.com
To: Samuel Ortiz <sameo@linux.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2] TWL4030: Initial support for TWL5031
In-Reply-To: <1255702360-2143-1-git-send-email-ilkka.koskinen@nokia.com>
Message-ID: <alpine.DEB.2.00.0911031243210.14058@tumpelo.ntc.nokia.com>
References: <1255702360-2143-1-git-send-email-ilkka.koskinen@nokia.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
X-OriginalArrivalTime: 03 Nov 2009 11:31:24.0519 (UTC) FILETIME=[2CC1FF70:01CA5C79]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Samuel,

On Fri, 16 Oct 2009, Koskinen Ilkka (Nokia-D/Tampere) wrote:
> TWL5031 introduces two new interrupts in PIH. Moreover, BCI
> has changed remarkably and, thus, it's disabled when TWL5031
> is in use.
>
> Signed-off-by: Ilkka Koskinen <ilkka.koskinen@nokia.com>
> ---
> drivers/mfd/twl4030-core.c  |   12 ++++-
> drivers/mfd/twl4030-irq.c   |  127 +++++++++++++++++++++++++++++++++++++++++--
> include/linux/i2c/twl4030.h |   47 ++++++++++++++--
> 3 files changed, 173 insertions(+), 13 deletions(-)

Sorry to bothering you again, but I'd like to know the status
of this patch. Does it need more work or could you apply it
to your tree at some point?

Cheers, Ilkka
