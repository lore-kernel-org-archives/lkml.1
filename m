Return-Path: <linux-kernel-owner+w=401wt.eu-S1754418AbXFDNf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754418AbXFDNf1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 09:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773AbXFDNfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 09:35:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55618 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752055AbXFDNfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 09:35:11 -0400
Date: Mon, 4 Jun 2007 14:40:18 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/2] serverworks: always tune CSB6
Message-ID: <20070604144018.0dbfa63b@the-village.bc.nu>
In-Reply-To: <200706032223.49063.bzolnier@gmail.com>
References: <200706032223.49063.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Looks good to me - and I can confirm no libata problem reports from us
always setting modes ourselves.

