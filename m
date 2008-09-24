Return-Path: <linux-kernel-owner+w=401wt.eu-S1755108AbYIXKXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108AbYIXKXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbYIXKW5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:22:57 -0400
Received: from mail-in-14.arcor-online.net ([151.189.21.54]:35440 "EHLO
	mail-in-14.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753834AbYIXKW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:22:56 -0400
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] RTC: Add platform data structure to Ricoh RS5C372 driver
To: Alexey Kopytko <alexey@kopytko.ru>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Wed, 24 Sep 2008 12:32:20 +0200
References: <bfsC3-6J9-5@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1KiRfR-0001CZ-53@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Kopytko <alexey@kopytko.ru> wrote:

> From: Alexey Kopytko <alexey@kopytko.ru>
> 
> This patch enables a platform developer to choose which alarm register to use.
> It adds and properly initializes platform data structure.

> +++ b/drivers/rtc/rtc-rs5c372.c

> +#define RS5C_REG_ALARM_A_WDAY        10

> +#define RS5C_REG_ALARM_B_WDAY        13                      /* (ALARM_B only) */

What is this comment supposed to tell?


