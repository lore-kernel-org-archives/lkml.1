Return-Path: <linux-kernel-owner+w=401wt.eu-S1760287AbXELUFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760287AbXELUFg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 16:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbXELUFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 16:05:30 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47232 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755143AbXELUF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 16:05:29 -0400
Date: Sat, 12 May 2007 21:09:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: default y idiocy
Message-ID: <20070512210944.52260991@the-village.bc.nu>
In-Reply-To: <20070512192726.GQ4629@kernel.dk>
References: <20070512182343.GO4629@kernel.dk>
	<Pine.LNX.4.61.0705122121340.9570@yvahk01.tjqt.qr>
	<20070512192726.GQ4629@kernel.dk>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, I don't buy that reason at all - it's a short term advantage,
> causing long term pain. It's not what we have done in the past, don't
> start doing crap like that now.

It doesn't really matter what it defaults too

cp .config somewheresafe

Install new kernel

cp it back

make oldconfig

Alan
