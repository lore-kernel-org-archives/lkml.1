Return-Path: <linux-kernel-owner+w=401wt.eu-S1758766AbYBRQGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758766AbYBRQGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 11:06:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbYBRQFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 11:05:53 -0500
Received: from gateway-1237.mvista.com ([63.81.120.155]:54420 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754156AbYBRQFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 11:05:51 -0500
Message-ID: <47B9AD1D.4020307@ru.mvista.com>
Date: Mon, 18 Feb 2008 19:06:53 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ide: remove PIO "downgrade" quirk
References: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
In-Reply-To: <20080217185105.16210.26582.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:

> No need for it nowadays

    Since which moment, could you elaborate

> so remove quirk code from ide_get_best_pio_mode()
> and IDE_HFLAG_PIO_DOWNGRADE host flag.

> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

MBR, Sergei
