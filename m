Return-Path: <linux-kernel-owner+w=401wt.eu-S969418AbXGaFGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969418AbXGaFGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 01:06:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753725AbXGaFGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 01:06:13 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:58764 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753816AbXGaFGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 01:06:12 -0400
Subject: Re: [patch 20/26] saa7134: fix thread shutdown handling
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       torvalds@linux-foundation.org, Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, jeffm@suse.com,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20070731043330.GU3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
	 <20070731043330.GU3975@kroah.com>
Content-Type: text/plain; charset=utf-8
Date: Tue, 31 Jul 2007 02:05:48 -0300
Message-Id: <1185858348.4407.69.camel@gaivota>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0-5mdv2007.1 
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Em Seg, 2007-07-30 às 21:33 -0700, Greg KH escreveu:
> anexo Documento somente texto
> (saa7134-fix-thread-shutdown-handling.patch)
> -stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Jeff Mahoney <jeffm@suse.com>
> 
> This patch changes the test for the thread pid from >= 0 to > 0.
> 
> When the saa8134 driver initialization fails after a certain point, it goes
	   ^^^^^^^
The patch is OK. however, the driver name is saa7134.

-- 
Cheers,
Mauro

