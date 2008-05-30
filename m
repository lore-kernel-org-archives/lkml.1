Return-Path: <linux-kernel-owner+w=401wt.eu-S1754238AbYE3LqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754238AbYE3LqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756063AbYE3Lpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:45:50 -0400
Received: from homer.mvista.com ([63.81.120.155]:15992 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755914AbYE3Lpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:45:49 -0400
Message-ID: <483FE8DE.8070502@ru.mvista.com>
Date: Fri, 30 May 2008 15:45:34 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/21] ide: move some bits from ide-timing.h to <linux/ide.h>
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain> <20080528214019.16327.16020.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528214019.16327.16020.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Move struct ide_timing and IDE_TIMING_* defines to <linux/ide.h>
> from drivers/ide/ide-timing.h.

> While at it:

> - use u8/u16 instead of short for struct ide_timing fields

> - use enum for IDE_TIMING_*

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

