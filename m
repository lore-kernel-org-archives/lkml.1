Return-Path: <linux-kernel-owner+w=401wt.eu-S1763430AbXGJLJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763430AbXGJLJl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757278AbXGJLJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:09:34 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59877 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbXGJLJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:09:33 -0400
Subject: Re: [PATCH] Remove apparently useless, commented
	apm_get_battery_status().
From: David Woodhouse <dwmw2@infradead.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
In-Reply-To: <Pine.LNX.4.64.0706040715520.32191@localhost.localdomain>
References: <Pine.LNX.4.64.0706040715520.32191@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 10 Jul 2007 12:09:30 +0100
Message-Id: <1184065770.1170.474.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 (2.10.2-2.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-04 at 07:15 -0400, Robert P. J. Day wrote:
> Remove the "#if 0"ed definition of apm_get_battery_status().
> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Nak. I think we want that when we implement the power_supply class
driver for APM batteries. Wanna write that driver? It shouldn't be hard.

-- 
dwmw2

