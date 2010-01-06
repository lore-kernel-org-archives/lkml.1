Return-Path: <linux-kernel-owner+w=401wt.eu-S932747Ab0AFU2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747Ab0AFU2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 15:28:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932554Ab0AFU2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 15:28:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54728
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932499Ab0AFU2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 15:28:20 -0500
Date: Wed, 06 Jan 2010 12:28:26 -0800 (PST)
Message-Id: <20100106.122826.233087809.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: jkosina@suse.cz, peterhuewe@gmx.de, kernel-janitors@vger.kernel.org,
       sshtylyov@ru.mvista.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ide: add __init/__exit macros to
 drivers/ide/scc_pata.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <201001051939.07756.bzolnier@gmail.com>
References: <1261470564-23754-2-git-send-email-peterhuewe@gmx.de>
	<alpine.LNX.2.00.1001051124150.2277@pobox.suse.cz>
	<201001051939.07756.bzolnier@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Tue, 5 Jan 2010 19:39:07 +0100

> We can fix it nowadays, though I worry that by fixing it we may be 'creating
> competition' for 'officially blessed yet unmaintained' PATA stack... 8-)

Not being able to unload a module is a bug isn't it?  Bug fixes
are always fine :-)

I'll take a closer look at this then apply it, thanks Bart!
