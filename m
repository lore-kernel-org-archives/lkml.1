Return-Path: <linux-kernel-owner+w=401wt.eu-S1761598AbXHCLmh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761598AbXHCLmh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 07:42:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760688AbXHCLma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 07:42:30 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:57003 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759804AbXHCLm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 07:42:29 -0400
Date: Fri, 3 Aug 2007 13:42:23 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 62] include/asm-avr32/pgalloc.h: kmalloc + memset
 conversion to kcalloc
Message-ID: <20070803134223.384702a7@siona>
In-Reply-To: <200707312341.01133.m.kozlowski@tuxland.pl>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
	<200707312341.01133.m.kozlowski@tuxland.pl>
Organization: Atmel
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2007 23:41:00 +0200
Mariusz Kozlowski <m.kozlowski@tuxland.pl> wrote:

> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

Applied, thanks. I found some other cruft in pgalloc.h which I cleaned
up as well.

Haavard
