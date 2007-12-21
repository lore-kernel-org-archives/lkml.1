Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbXLUMML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbXLUMML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbXLUML5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:11:57 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:30287 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651AbXLUML4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:11:56 -0500
Message-ID: <476BADA1.9040209@ru.mvista.com>
Date: Fri, 21 Dec 2007 15:12:17 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 12/63] ide-cd: fix "missing data" handling in cdrom_pc_intr()
References: <200712200201.31860.bzolnier@gmail.com>
In-Reply-To: <200712200201.31860.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> If drive still wants to transfer the data we need to pad the transfer
> instead of just finishing the request.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
