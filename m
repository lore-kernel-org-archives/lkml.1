Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbZCJPF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbZCJPF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 11:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZCJPFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 11:05:12 -0400
Received: from h155.mvista.com ([63.81.120.155]:51216 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754308AbZCJPFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 11:05:11 -0400
Message-ID: <49B681CE.2060409@ru.mvista.com>
Date: Tue, 10 Mar 2009 18:05:50 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/10] ide: set/clear drive->waiting_for_dma flag in the
 core code
References: <20090220171139.25429.26702.sendpatchset@localhost.localdomain> <20090220171243.25429.21171.sendpatchset@localhost.localdomain>
In-Reply-To: <20090220171243.25429.21171.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Set/clear drive->waiting_for_dma flag in the core code
> instead of in ->dma_setup and ->dma_end methods.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
