Return-Path: <linux-kernel-owner+w=401wt.eu-S1753274Ab0AUERX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab0AUERX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 23:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280Ab0AUERU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 23:17:20 -0500
Received: from mail-yw0-f198.google.com ([209.85.211.198]:59264 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab0AUERT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 23:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=xkCryMK3l6Zi2mEgy5DPelIqFbfIHF3nvKvJHA3BSJwxCEks58ri1L1mgsZYbRi+wl
         WLJwi4J5b5oCoZX6xCHPIaA7wcJLI/aFaYjp7n57xA55KgHMEiv05e2E7r7GMIIzJKAG
         hY3w3qWHBcx5Osh047xIzHVLi8edSCB30+xXk=
Message-ID: <4B57D54D.7000707@garzik.org>
Date: Wed, 20 Jan 2010 23:17:17 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/64] pata_efar: fix secondary port support
References: <20100118171349.14623.90030.sendpatchset@localhost> <20100118171603.14623.7966.sendpatchset@localhost>
In-Reply-To: <20100118171603.14623.7966.sendpatchset@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2010 12:16 PM, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> Subject: [PATCH] pata_efar: fix secondary port support
>
> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
> ---
>   drivers/ata/pata_efar.c |    4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

patches 16-17 OK, but did not apply due to missing patch 15


