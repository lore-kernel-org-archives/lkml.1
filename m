Return-Path: <linux-kernel-owner+w=401wt.eu-S1759817AbXEIWrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759817AbXEIWrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 18:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbXEIWr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 18:47:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:49577 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755806AbXEIWrZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 18:47:25 -0400
Message-ID: <46424F7B.8060004@garzik.org>
Date: Wed, 09 May 2007 18:47:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [git patches] IDE update
References: <200705100046.05280.bzolnier@gmail.com>
In-Reply-To: <200705100046.05280.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> * the code for selecting and programming the best DMA transfer mode
>   has been reworked to be cleaner, more generic and more libata-like,
>   (> 500 LOCs gone and this change allows the change described below)

> Bartlomiej Zolnierkiewicz (11):
>       ide: rework the code for selecting the best DMA transfer mode (v3)


Has this seen testing/exposure in -mm tree?

	Jeff


