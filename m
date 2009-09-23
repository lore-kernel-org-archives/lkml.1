Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZIWJPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZIWJPQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 05:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752897AbZIWJPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 05:15:13 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:49050 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886AbZIWJPK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 05:15:10 -0400
Date: Wed, 23 Sep 2009 10:11:21 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Florian Fainelli <florian@openwrt.org>, Maxime Bizon <mbizon@freebox.fr>,
       linux-mips <linux-mips@linux-mips.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MIPS: includecheck fix: bcm63xx, board_bcm963xx.c
Message-ID: <20090923091121.GA5457@linux-mips.org>
References: <1253626037.3784.13.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253626037.3784.13.camel@ht.satnam>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 06:57:17PM +0530, Jaswinder Singh Rajput wrote:

> fix the following 'make includecheck' warning:
> 
>   arch/mips/bcm63xx/boards/board_bcm963xx.c: bcm63xx_board.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

I've already merged a patch which didn't yet make it to kernel.org for this
issue a few days ago.

Thanks anyway!

  Ralf
