Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYJPJs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYJPJs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754400AbYJPJsR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:48:17 -0400
Received: from h155.mvista.com ([63.81.120.155]:53832 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753710AbYJPJsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:48:14 -0400
Message-ID: <48F70DDA.4010805@ru.mvista.com>
Date: Thu, 16 Oct 2008 13:48:10 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: remove broken hpt34x driver
References: <200810152156.25754.bzolnier@gmail.com>
In-Reply-To: <200810152156.25754.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

> No big loss since HPT343/363 controllers are properly supported
> by pata_hpt3x3 driver from Alan Cox.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>   

   Hum, interesting way of fixing the driver... :-)
   Shouldn't the PCI IDs be added to drivers/ide/pci/generic.c?

MBR, Sergei


