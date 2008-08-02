Return-Path: <linux-kernel-owner+w=401wt.eu-S1757301AbYHBRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301AbYHBRqS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752355AbYHBRqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 13:46:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51095 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054AbYHBRqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 13:46:04 -0400
Subject: Re: [PATCH 6/10] drivers/mtd: Use DIV_ROUND_UP
From: David Woodhouse <dwmw2@infradead.org>
To: Julia Lawall <julia@diku.dk>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0808021713580.20095@ask.diku.dk>
References: <Pine.LNX.4.64.0808021713580.20095@ask.diku.dk>
Content-Type: text/plain
Date: Sat, 02 Aug 2008 18:45:43 +0100
Message-Id: <1217699143.3719.58.camel@shinybook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-02 at 17:14 +0200, Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) -
> 1) / (d)) but is perhaps more readable.

Applied; thanks.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

