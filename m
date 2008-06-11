Return-Path: <linux-kernel-owner+w=401wt.eu-S1755154AbYFKWK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbYFKWK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbYFKWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:10:50 -0400
Received: from h155.mvista.com ([63.81.120.155]:63901 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750782AbYFKWKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:10:49 -0400
Message-ID: <48504D63.3030207@ru.mvista.com>
Date: Thu, 12 Jun 2008 02:10:43 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Juergen Kosel <juergen.kosel@gmx.de>
Subject: Re: [PATCH 2/6] opti621: remove DMA support
References: <200806112158.18354.bzolnier@gmail.com>
In-Reply-To: <200806112158.18354.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:
> These controllers don't support DMA.
>
> Based on a bugreport from Juergen Kosel & inspired by pata_opti.c code.
>
> Tested-by: Juergen Kosel <juergen.kosel@gmx.de>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>
>   

   Verily. I have the 82C621A datasheet.

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

MBR, Sergei


