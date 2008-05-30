Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYE3Lqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYE3Lqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbYE3LqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:46:17 -0400
Received: from homer.mvista.com ([63.81.120.155]:16005 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754163AbYE3LqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:46:15 -0400
Message-ID: <483FE8FC.4070902@ru.mvista.com>
Date: Fri, 30 May 2008 15:46:04 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/21] ide: remove XFER_* masks from ide-timing.h
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain> <20080528214027.16327.95083.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528214027.16327.95083.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> * Check requested xfer mode against xfer modes instead of XFER_* masks
>   in ide_timing_compute() and cs5535.c::cs5535_set_speed().

> * Remove XFER_[MODE,MWDMA,EPIO,PIO] masks.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
