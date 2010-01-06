Return-Path: <linux-kernel-owner+w=401wt.eu-S932810Ab0AFU6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab0AFU6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:58:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932795Ab0AFU6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:58:16 -0500
Received: from mail.gmx.net ([213.165.64.20]:35907 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932793Ab0AFU6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:58:14 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/B0yl7k+vBSwX0JNQUCWJQ5/FLj9el3KgoEycsPD
	X2NurgeSJdNZ5s
From: Peter Huewe <PeterHuewe@gmx.de>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 2/2] ide: add __init/__exit macros to drivers/ide/scc_pata.c
Date: Wed, 6 Jan 2010 21:58:01 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: bzolnier@gmail.com, jkosina@suse.cz, kernel-janitors@vger.kernel.org,
       sshtylyov@ru.mvista.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <1261470564-23754-2-git-send-email-peterhuewe@gmx.de> <201001051939.07756.bzolnier@gmail.com> <20100106.122826.233087809.davem@davemloft.net>
In-Reply-To: <20100106.122826.233087809.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001062158.01870.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch 06 Januar 2010 21:28:26 schrieb David Miller:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 5 Jan 2010 19:39:07 +0100
> 
> 
> Not being able to unload a module is a bug isn't it?  Bug fixes
> are always fine :-)
> 
> I'll take a closer look at this then apply it, thanks Bart!

Funny what such trivial patch can reveal :)

Regards,
Peter
