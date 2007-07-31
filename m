Return-Path: <linux-kernel-owner+w=401wt.eu-S934051AbXGaSxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934051AbXGaSxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762330AbXGaSxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:53:43 -0400
Received: from ftp.linux-mips.org ([194.74.144.162]:42054 "EHLO
	ftp.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757812AbXGaSxm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:53:42 -0400
Date: Tue, 31 Jul 2007 19:53:37 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org
Subject: Re: [PATCH 48] include/asm-mips/thread_info.h: kmalloc + memset
	conversion to kzalloc
Message-ID: <20070731185337.GA30328@linux-mips.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312048.42172.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707312048.42172.m.kozlowski@tuxland.pl>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 08:48:41PM +0200, Mariusz Kozlowski wrote:

Thanks, applied.
