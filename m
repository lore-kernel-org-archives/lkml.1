Return-Path: <linux-kernel-owner+w=401wt.eu-S1762241AbYBCRHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762241AbYBCRHO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 12:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbYBCRHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 12:07:00 -0500
Received: from h155.mvista.com ([63.81.120.155]:54918 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756664AbYBCRHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 12:07:00 -0500
Message-ID: <47A5F4E8.2000403@ru.mvista.com>
Date: Sun, 03 Feb 2008 20:07:52 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ide: remove write-only ->sata_misc[] from ide_hwif_t
References: <200802020145.40429.bzolnier@gmail.com>
In-Reply-To: <200802020145.40429.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Remove write-only ->sata_misc[] from ide_hwif_t.

> * Remove no longer used SATA_{MISC,PHY,IEN}_OFFSET defines.

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei
