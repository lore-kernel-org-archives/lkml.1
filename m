Return-Path: <linux-kernel-owner+w=401wt.eu-S1754873AbZAKVSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873AbZAKVSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 16:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbZAKVSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 16:18:44 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:13309 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751023AbZAKVSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 16:18:43 -0500
Message-ID: <496A622E.4080905@ru.mvista.com>
Date: Mon, 12 Jan 2009 00:18:38 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] ide: move ide_pktcmd_tf_load() to ide-atapi.c
References: <20090106183520.21193.63704.sendpatchset@localhost.localdomain> <20090106183547.21193.43620.sendpatchset@localhost.localdomain>
In-Reply-To: <20090106183547.21193.43620.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Then make it static and remove 'dma' argument.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


