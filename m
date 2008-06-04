Return-Path: <linux-kernel-owner+w=401wt.eu-S1759744AbYFDJne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759744AbYFDJne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753243AbYFDJnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:43:25 -0400
Received: from h155.mvista.com ([63.81.120.155]:12044 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752444AbYFDJnY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:43:24 -0400
Message-ID: <484663B7.2080902@ru.mvista.com>
Date: Wed, 04 Jun 2008 13:43:19 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] au1xxx-ide: don't use hwif->hwif_data
References: <20080602202253.7265.23590.sendpatchset@localhost.localdomain> <20080602202347.7265.36700.sendpatchset@localhost.localdomain>
In-Reply-To: <20080602202347.7265.36700.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> * Use &auide_hwif directly instead of using hwif->hwif_data.
>
> While at it:
>
> * No need to initialize hwif->{select,config}_data.
>
> There should be no functional changes caused by this patch.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   
Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


