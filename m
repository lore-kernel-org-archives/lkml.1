Return-Path: <linux-kernel-owner+w=401wt.eu-S966302AbXDGTO0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966302AbXDGTO0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Apr 2007 15:14:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966304AbXDGTO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Apr 2007 15:14:26 -0400
Received: from mail.gmx.net ([213.165.64.20]:49550 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S966302AbXDGTOZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Apr 2007 15:14:25 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX183S7xi+iE3Rz72vYZEAqgIn8As0xJTlmiOBDmGUC
	RW857EmaVpO8dh
Subject: Re: Ten percent test
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>, ck list <ck@vds.kolivas.org>
In-Reply-To: <20070407180818.GB23861@elte.hu>
References: <200703290237.38777.kernel@kolivas.org>
	 <20070406100333.GA19855@elte.hu> <200704071650.43905.kernel@kolivas.org>
	 <200704071212.57401.gene.heskett@gmail.com>
	 <20070407180818.GB23861@elte.hu>
Content-Type: text/plain
Date: Sat, 07 Apr 2007 21:14:21 +0200
Message-Id: <1175973261.6288.2.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2007-04-07 at 20:08 +0200, Ingo Molnar wrote:
> * Gene Heskett <gene.heskett@gmail.com> wrote:

> > (who the hell runs a 'make -j 200' or 50 while(1)'s in the real world?
> 
> not many - and i dont think Mike tested any of these - Mike tested 
> pretty low make -j values (Mike, can you confirm?).

Yes.  I don't test anything more than make -j5 when looking at
interactivity, and make -j nr_cpus+1 is my must have yardstick.

	-Mike

