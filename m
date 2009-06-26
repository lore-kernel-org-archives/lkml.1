Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbZFZQTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbZFZQTR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 12:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752114AbZFZQTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 12:19:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:53728 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbZFZQTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 12:19:03 -0400
Subject: RE: [PATCH][MTD][NAND]: fix omap2.c compile failure and warning
From: David Woodhouse <dwmw2@infradead.org>
To: "Singh, Vimal" 
	<IMCEAEX-_O=TI_OU=BD_CN=RECIPIENTS_CN=X0094262@dlee86.itg.ti.com>
Cc: "tom.leiming@gmail.com" <tom.leiming@gmail.com>,
       "jzhang@ti.com" <jzhang@ti.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "david-b@pacbell.net" <david-b@pacbell.net>
In-Reply-To: <19F8576C6E063C45BE387C64729E739404321C60D1@dbde02.ent.ti.com>
References: <1246022509-16194-1-git-send-email-tom.leiming@gmail.com>
	 ,<1246028984.663.9.camel@macbook.infradead.org>
	 <19F8576C6E063C45BE387C64729E739404321C60D1@dbde02.ent.ti.com>
Content-Type: text/plain
Date: Fri, 26 Jun 2009 17:18:59 +0100
Message-Id: <1246033139.663.35.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-26 at 21:15 +0530, Singh, Vimal wrote:
> 
> That's correct David. I think 'cond_resched()' would be fine here.

Got a patch? I have you down as the person responsible for this driver,
given that jzhang@ti.com is bouncing... 

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

