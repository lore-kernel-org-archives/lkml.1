Return-Path: <linux-kernel-owner+w=401wt.eu-S1762927AbXJENXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762927AbXJENXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 09:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXJENXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 09:23:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37048 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbXJENXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 09:23:47 -0400
Subject: Re: [PATCH] Replace __attribute_pure__ with __pure
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>, aubrey.li@analog.com,
       bernd.schmidt@analog.com, bryan.wu@analog.com, grace.pan@analog.com,
       marc.hoffman@analog.com, michael.hennerich@analog.com,
       michael.frysinger@analog.com, jerry.zeng@analog.com,
       jie.zhang@analog.com, robin.getz@analog.com, roy.huang@analog.com,
       sonic.zhang@analog.com, vivi.li@analog.com, yi.li@analog.com,
       paulus@samba.org, linux-kernel@vger.kernel.org
In-Reply-To: <20071005131309.GA445@linux-mips.org>
References: <20071005131309.GA445@linux-mips.org>
Content-Type: text/plain; charset=utf-8
Date: Fri, 05 Oct 2007 10:23:23 -0300
Message-Id: <1191590603.4864.163.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0-2mdv2008.0 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Em Sex, 2007-10-05 às 14:13 +0100, Ralf Baechle escreveu:
> To be consistent with the use of attributes in the rest of the kernel
> replace all use of __attribute_pure__ with __pure and delete the
> definition of __attribute_pure__.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>
 
Cheers,
Mauro

