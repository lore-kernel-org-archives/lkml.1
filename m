Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZAES62@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZAES62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 13:58:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZAES6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 13:58:17 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40086 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752332AbZAES6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 13:58:16 -0500
Date: Mon, 5 Jan 2009 18:58:32 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] block: export SSD/non-rotational queue flag through
 sysfs
Message-ID: <20090105185832.764cfef0@lxorguk.ukuu.org.uk>
In-Reply-To: <200901051952.58029.bzolnier@gmail.com>
References: <200901051952.58029.bzolnier@gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Jan 2009 19:52:57 +0100
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] block: export SSD/non-rotational queue flag through sysfs
> 
> For some devices (i.e. CFA ATA) we can't reliably detect whether
> the device is of rotational or non-rotational type so we need to
> leave the final decision about this setting to the user-space.
> 
> Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>

Nice - exactly what is needed

Acked-by: Alan Cox <alan@redhat.com>
