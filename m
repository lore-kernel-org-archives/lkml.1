Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYHTJ6P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYHTJ6P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 05:58:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751475AbYHTJ55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 05:57:57 -0400
Received: from h155.mvista.com ([63.81.120.155]:29024 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750932AbYHTJ54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 05:57:56 -0400
Message-ID: <48ABEA9D.8040804@ru.mvista.com>
Date: Wed, 20 Aug 2008 13:57:49 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/9] ide: remove [ata_]select_t
References: <20080817195336.13393.86030.sendpatchset@localhost.localdomain> <20080817195411.13393.22229.sendpatchset@localhost.localdomain>
In-Reply-To: <20080817195411.13393.22229.sendpatchset@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> * Use 'drive->dn & 1' in ide_init_disk().
>
> * remove [ata_]select_t.
>
> While at it:
>
> * Use ATA_DEVICE_OBS define in ide_port_init_devices_data().
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


