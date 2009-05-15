Return-Path: <linux-kernel-owner+w=401wt.eu-S1763164AbZEOMSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763164AbZEOMSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 08:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762462AbZEOMQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 08:16:20 -0400
Received: from h155.mvista.com ([63.81.120.155]:34378 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762766AbZEOMQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 08:16:19 -0400
Message-ID: <4A0D5D3C.4000805@ru.mvista.com>
Date: Fri, 15 May 2009 16:17:00 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] ide: remove hw_regs_t typedef
References: <20090513205139.28638.87226.sendpatchset@localhost.localdomain> <20090513205231.28638.12447.sendpatchset@localhost.localdomain>
In-Reply-To: <20090513205231.28638.12447.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> Remove hw_regs_t typedef and rename struct hw_regs_s to struct ide_hw.

> There should be no functional changes caused by this patch.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei

