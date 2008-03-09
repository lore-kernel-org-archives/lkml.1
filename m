Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbYCIUMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbYCIUMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 16:12:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754052AbYCIUMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 16:12:40 -0400
Received: from h155.mvista.com ([63.81.120.155]:36938 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753291AbYCIUMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 16:12:40 -0400
Message-ID: <47D44503.6060006@ru.mvista.com>
Date: Sun, 09 Mar 2008 23:13:55 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] ide: don't display "BIOS" settings in ide_setup_dma()
References: <200803082229.34542.bzolnier@gmail.com>
In-Reply-To: <200803082229.34542.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> Nowadays BIOS info is not very useful and only confuses users since:

> - IDE always tries to use DMA

> - BIOS info may not be accurate with modular IDE/libata

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
