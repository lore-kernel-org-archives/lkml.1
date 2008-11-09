Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYKIRPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYKIRPA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 12:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYKIROv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 12:14:51 -0500
Received: from h155.mvista.com ([63.81.120.155]:32754 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755434AbYKIROv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:14:51 -0500
Message-ID: <49171A89.6070205@ru.mvista.com>
Date: Sun, 09 Nov 2008 20:14:49 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 07/11] ide: use ATA_DMA_* defines in ide-dma-sff.c
References: <20081109162219.18999.74912.sendpatchset@localhost.localdomain> <20081109162301.18999.9793.sendpatchset@localhost.localdomain>
In-Reply-To: <20081109162301.18999.9793.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> In few places open-coded values were still being used.  Fix it.

   Oh, you've beaten me to it (and made one of my still pending patches 
unapplcable :-).

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
