Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYBRRAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYBRRAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 12:00:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYBRQ7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:59:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:55117 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751799AbYBRQ7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:59:52 -0500
Message-ID: <47B9B9C3.9060903@ru.mvista.com>
Date: Mon, 18 Feb 2008 20:00:51 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] qd65xx: return error value in qd_probe()
References: <20080216202634.25536.78915.sendpatchset@localhost.localdomain> <20080216202722.25536.36800.sendpatchset@localhost.localdomain>
In-Reply-To: <20080216202722.25536.36800.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Return error value in qd_probe() and use it in qd65xx_init()
> instead of checking ide_hwifs[].chipset.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
