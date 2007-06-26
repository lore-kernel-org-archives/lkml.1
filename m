Return-Path: <linux-kernel-owner+w=401wt.eu-S1759352AbXFZSZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759352AbXFZSZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 14:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757865AbXFZSZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 14:25:13 -0400
Received: from h155.mvista.com ([63.81.120.155]:41273 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752379AbXFZSZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 14:25:11 -0400
Message-ID: <46815A70.9060608@ru.mvista.com>
Date: Tue, 26 Jun 2007 22:26:56 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] alim15x3: backport short cables support from pata_ali.c
References: <200706101558.28262.bzolnier@gmail.com>
In-Reply-To: <200706101558.28262.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Backport short cables support from pata_ali.c and while at it cleanup
> existing cable detection code.

> This patch should allow UDMA > 2 modes on HP Pavilion N5430 and Fujitsu P2000.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
