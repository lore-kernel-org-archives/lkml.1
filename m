Return-Path: <linux-kernel-owner+w=401wt.eu-S1030287AbXAYQTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030287AbXAYQTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 11:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030272AbXAYQTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 11:19:18 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:53913 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030287AbXAYQTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 11:19:17 -0500
Subject: Re: [PATCH] libata-sff: Don't call bmdma_stop on non DMA capable
	controllers
From: David Woodhouse <dwmw2@infradead.org>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, torvalds@osdl.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <45B8D810.3030501@pobox.com>
References: <20070125150905.652f9ce2@localhost.localdomain>
	 <1169741658.3593.98.camel@shinybook.infradead.org>
	 <45B8D810.3030501@pobox.com>
Content-Type: text/plain
Date: Fri, 26 Jan 2007 00:19:00 +0800
Message-Id: <1169741940.3593.104.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-01-25 at 11:17 -0500, Jeff Garzik wrote:
> Read the code...  This test is already widely in use in libata. 

That doesn't make it correct; it just means it's your fault not Alan's,
right? :)

-- 
dwmw2

