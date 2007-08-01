Return-Path: <linux-kernel-owner+w=401wt.eu-S1763027AbXHAAM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763027AbXHAAM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 20:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbXHAAMU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 20:12:20 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:46294 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752642AbXHAAMT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 20:12:19 -0400
Date: Wed, 1 Aug 2007 01:19:33 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 09] drivers/char/consolemap.c: kmalloc + memset
 conversion to kzalloc
Message-ID: <20070801011933.263f3b21@the-village.bc.nu>
In-Reply-To: <200707311908.28679.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707311908.28679.m.kozlowski@tuxland.pl>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 19:08:28 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Acked-by: Alan Cox <alan@redhat.com>

