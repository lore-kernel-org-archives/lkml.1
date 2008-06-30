Return-Path: <linux-kernel-owner+w=401wt.eu-S1760220AbYF3Pfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760220AbYF3Pfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 11:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763389AbYF3Pcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 11:32:46 -0400
Received: from yw-out-2324.google.com ([74.125.46.31]:64099 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763381AbYF3Pco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 11:32:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DSzn7wNeIf00TjP4lyfHpc98atd6ergevBr+rv1+K3oGZZ7eKWLzL/XMlGLT2BhaQd
         cqu4F5Wiu2pXxzoarEXpwp+vEDrxGkYS5T66/3VkK6mQi/D1Bv3mfY/i2hMJ2K/g+UCh
         tMhMZIrpIo1o+w//XQkCGmBmEuOaSQ54DkGW8=
Date: Mon, 30 Jun 2008 19:32:32 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: linux-kernel@vger.kernel.org, cbou@mail.ru, dwmw2@infradead.org
Subject: Re: [PATCH] Add support for power_supply on tosa
Message-ID: <20080630153232.GA4785@doriath.ww600.siemens.net>
References: <20080620084917.GA20577@doriath.ww600.siemens.net> <20080623061943.GA6080@zarina> <20080624145107.GB31719@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080624145107.GB31719@doriath.ww600.siemens.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2008 at 06:51:07PM +0400, Dmitry Baryshkov wrote:
> Hi,
> 
> Please consider this updated version
> 
> From 314de1f70b669344f5b26ac2e4f8854a9024f17a Mon Sep 17 00:00:00 2001
> From: Dmitry Baryshkov <dbaryshkov@gmail.com>
> Date: Tue, 24 Jun 2008 18:50:18 +0400
> Subject: [PATCH] Add support for power_supply on tosa
> 
> Signed-off-by: Dmitry Baryshkov <dbaryshkov@gmail.com>
> ---
>  drivers/power/Kconfig        |    7 +
>  drivers/power/Makefile       |    1 +
>  drivers/power/tosa_battery.c |  487 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 495 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/power/tosa_battery.c
> 

Any comments regarding this version?

-- 
With best wishes
Dmitry

