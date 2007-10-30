Return-Path: <linux-kernel-owner+w=401wt.eu-S1753665AbXJ3Mt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbXJ3Mt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 08:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbXJ3MtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 08:49:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:42057 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037AbXJ3MtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 08:49:18 -0400
Subject: Re: [PATCH 11/16] CRIS architecture: Correct compile errors
From: David Woodhouse <dwmw2@infradead.org>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20071030093353.GN11960@axis.com>
References: <20071030093353.GN11960@axis.com>
Content-Type: text/plain
Date: Tue, 30 Oct 2007 08:49:32 -0400
Message-Id: <1193748572.2915.165.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 10:33 +0100, Jesper Nilsson wrote:
> Add include file with prototype for mtdram_init_device from
> drivers/mtd/devices/mtdram.c.
> Used by axisflashmap.c to boot from ram.
> 
> Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

Reviewed-by: David Woodhouse <dwmw2@infradead.org>

You want this to go via the mtd git tree, or with the rest of your
patches?

-- 
dwmw2

