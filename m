Return-Path: <linux-kernel-owner+w=401wt.eu-S1755341AbZCHWWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbZCHWWt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 18:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754224AbZCHWWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 18:22:40 -0400
Received: from h155.mvista.com ([63.81.120.155]:6042 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753521AbZCHWWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 18:22:39 -0400
Message-ID: <49B44528.5040308@ru.mvista.com>
Date: Mon, 09 Mar 2009 01:22:32 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/10] ns87415: use custom ->dma_{start,end} to handle
 ns87415_prepare_drive()
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171215.25429.46593.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171215.25429.46593.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Use custom ->dma_{start,end} methods to handle ns87415_prepare_drive()
> there instead of in ->dma_setup method.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


