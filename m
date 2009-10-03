Return-Path: <linux-kernel-owner+w=401wt.eu-S1754180AbZJCIxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180AbZJCIxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 04:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752642AbZJCIxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 04:53:18 -0400
Received: from mail.gmx.net ([213.165.64.20]:43369 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751371AbZJCIxO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 04:53:14 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/FUddpwPbFgYUTmbXrLtyMraDmrcAjQv/vje7d7k
	PR0uNBJEpLEi2G
Subject: Re: IO scheduler based IO controller V10
From: Mike Galbraith <efault@gmx.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       riel@redhat.com
In-Reply-To: <20091003072540.GW31616@kernel.dk>
References: <alpine.LFD.2.01.0910020811490.6996@localhost.localdomain>
	 <20091002171129.GG31616@kernel.dk> <20091002172046.GA2376@elte.hu>
	 <20091002172554.GJ31616@kernel.dk> <20091002172842.GA4884@elte.hu>
	 <20091002173732.GK31616@kernel.dk>
	 <1254507215.8667.7.camel@marge.simson.net>
	 <20091002181903.GN31616@kernel.dk>
	 <1254548931.8299.18.camel@marge.simson.net>
	 <20091003072021.GB21407@elte.hu>  <20091003072540.GW31616@kernel.dk>
Content-Type: text/plain
Date: Sat, 03 Oct 2009 10:53:08 +0200
Message-Id: <1254559988.17052.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-10-03 at 09:25 +0200, Jens Axboe wrote:
> On Sat, Oct 03 2009, Ingo Molnar wrote:

> Oh and Mike, I forgot to mention this in the previous email - no more
> tunables, please. We'll keep this under a single knob.

OK.

Since I don't seem to be competent to operate quilt this morning anyway,
I won't send a fixed version yet.  Anyone who wants to test can easily
fix the rename booboo.  With the knob in place, it's easier to see what
load is affected by what change.

Back to rummage/test.

	-Mike

