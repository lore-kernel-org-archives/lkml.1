Return-Path: <linux-kernel-owner+w=401wt.eu-S1756834AbYGHJAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbYGHJAb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 05:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751259AbYGHJAX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 05:00:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53494
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751240AbYGHJAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 05:00:22 -0400
Date: Tue, 08 Jul 2008 02:00:22 -0700 (PDT)
Message-Id: <20080708.020022.117832147.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: jeff@garzik.org, mchan@broadcom.com, dwmw2@infradead.org,
       bastian@waldi.eu.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2 - use request_firmware()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080708074132.7d403e98@the-village.bc.nu>
References: <20080707221950.3dfba435@the-village.bc.nu>
	<487293F8.30405@garzik.org>
	<20080708074132.7d403e98@the-village.bc.nu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Tue, 8 Jul 2008 07:41:32 +0100

> On Mon, 07 Jul 2008 18:08:56 -0400
> > Where is this enormous pain associated with tg3's compiled-in firmware? 
> >   It's been quite convenient.
> 
> How many kernel updates do you think all the worlds users and
> distributors have transferred. How much bandwidth and time do you think
> that cost ?

Sometimes we pay a price for being able to sleep at night.

How many cpus in the world have burned useless cycles computing the
SHA1 checksum of some file's contents for GIT :-)

