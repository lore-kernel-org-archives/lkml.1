Return-Path: <linux-kernel-owner+w=401wt.eu-S933390AbYGQTiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933390AbYGQTiP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:38:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932258AbYGQThl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:37:41 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:63503 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932799AbYGQThj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:37:39 -0400
Date: Thu, 17 Jul 2008 21:14:06 +0200
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Pierre Ossman <drzeus@drzeus.cx>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix avr32 build errors
Message-ID: <20080717211406.17c46637@siona.local>
In-Reply-To: <20080717134511.GA18502@cs181140183.pp.htv.fi>
References: <20080717134511.GA18502@cs181140183.pp.htv.fi>
Organization: Atmel
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2008 19:14:09.0933 (UTC) FILETIME=[4A6E73D0:01C8E841]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 16:45:11 +0300
Adrian Bunk <bunk@kernel.org> wrote:

> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/avr32/boards/atstk1000/atstk1003.c:157: error: too few arguments to function 'at32_add_device_mci'
> make[2]: *** [arch/avr32/boards/atstk1000/atstk1003.o] Error 1
> 
> <--  snip  -->
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks a lot. Shame on me for not testing all defconfigs
before submitting.

Haavard
