Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618AbXLIAFW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618AbXLIAFW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 19:05:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753025AbXLIAFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 19:05:10 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55139 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752996AbXLIAFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 19:05:09 -0500
Date: Sat, 8 Dec 2007 16:04:49 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.23.9 64-bit IRQ sharing without irqbalance with p35 vs
 i965?
Message-ID: <20071208160449.033aaece@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0712081842250.12499@p34.internal.lan>
References: <Pine.LNX.4.64.0712081842250.12499@p34.internal.lan>
Organization: Intel
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Dec 2007 18:44:39 -0500 (EST)
Justin Piszcz <jpiszcz@lucidpixels.com> wrote:

> Can some please explain with almost identical kernel .config's I see
> this on a p965 Intel board:

your bios programmed the machines differently...

the p965 has the higher performing settup, but still it's recommended
to run the http://www.irqbalance.org program to spread interrupts around


-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
