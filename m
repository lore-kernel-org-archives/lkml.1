Return-Path: <linux-kernel-owner+w=401wt.eu-S1750925AbXDHLky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750925AbXDHLky (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 07:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750898AbXDHLky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 07:40:54 -0400
Received: from mail.gmx.net ([213.165.64.20]:50482 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750755AbXDHLkx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 07:40:53 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+GRuBPc4aGVvIa9gWx6eAKgjCPty2X5CZcJviByV
	ZP/EjvZ4ELKP99
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <200704080733.39303.gene.heskett@gmail.com>
References: <200703290237.38777.kernel@kolivas.org>
	 <200704071630.25830.gene.heskett@gmail.com>
	 <20070408104125.GB11123@elte.hu>
	 <200704080733.39303.gene.heskett@gmail.com>
Content-Type: text/plain
Date: Sun, 08 Apr 2007 13:40:50 +0200
Message-Id: <1176032450.6304.3.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-08 at 07:33 -0400, Gene Heskett wrote:

> That seems to be the killer loading here, building a kernel (make -j3) 
> doesn't seem to lag it all that bad.  One session of gzip -best makes it 
> fall plumb over though, which was a disappointment.

Can you make a testcase that doesn't require amanda?

	-Mike

