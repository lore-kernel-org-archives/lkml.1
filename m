Return-Path: <linux-kernel-owner+w=401wt.eu-S1762046AbXHNOiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762046AbXHNOiu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 10:38:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760789AbXHNOiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 10:38:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33891 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760319AbXHNOiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 10:38:11 -0400
Subject: Re: [PATCH] [1/2many] - FInd the maintainer(s) for a patch -
	scripts/get_maintainer.pl
From: Arjan van de Ven <arjan@infradead.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Joe Perches <joe@perches.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
In-Reply-To: <20070814142205.GP18945@stusta.de>
References: <1186984174.10249.7.camel@localhost>
	 <200708131933.10125.m.kozlowski@tuxland.pl>
	 <1187026955.2688.4.camel@laptopd505.fenrus.org>
	 <1187037445.6628.98.camel@heimdal.trondhjem.org>
	 <1187054366.2757.0.camel@laptopd505.fenrus.org>
	 <20070814142205.GP18945@stusta.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Tue, 14 Aug 2007 07:33:58 -0700
Message-Id: <1187102038.3537.11.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.6.1 (2.11.6.1-1.fc8) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-08-14 at 16:22 +0200, Adrian Bunk wrote:
> > people tend to update .c files a lot better than way off-the-side other
> > files.
> 
> The move of netdev to vger would have required updating
> approx. 1300 C files...


and your point is?
This is an easily sed-able operation with a single git commit. 
BIG DEAL... NOT.

-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

