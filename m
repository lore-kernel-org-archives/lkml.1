Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbXLYK0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbXLYK0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2007 05:26:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbXLYKZx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Dec 2007 05:25:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:52303 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751206AbXLYKZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2007 05:25:52 -0500
Message-ID: <4770DACD.2080503@ru.mvista.com>
Date: Tue, 25 Dec 2007 13:26:21 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ide: add ide_dump_identify() debug helper
References: <200712232243.36838.bzolnier@gmail.com>
In-Reply-To: <200712232243.36838.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Add ide_dump_identify() debug helper for dumping raw identify data in
>   the hdparm friendly format (== the identify data can be extracted from
>   dmesg output and passed to hdparm --Istdin).

> * Dump identify data in ide-probe.c::do_identify() if DEBUG is enabled.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
