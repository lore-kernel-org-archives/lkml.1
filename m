Return-Path: <linux-kernel-owner+w=401wt.eu-S1757864AbYE3LrF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757864AbYE3LrF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 07:47:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbYE3Lqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 07:46:49 -0400
Received: from homer.mvista.com ([63.81.120.155]:16013 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752765AbYE3Lqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 07:46:48 -0400
Message-ID: <483FE91C.7030406@ru.mvista.com>
Date: Fri, 30 May 2008 15:46:36 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/21] ide: checkpatch.pl fixes for ide-timing.h
References: <20080528213944.16327.92950.sendpatchset@localhost.localdomain> <20080528214035.16327.47067.sendpatchset@localhost.localdomain>
In-Reply-To: <20080528214035.16327.47067.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Also fix placement of comments in ide_timing_compute() while at it.

> There should be no functional changes caused by this patch
> (md5sum was verified to be the same before/after the patch).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
