Return-Path: <linux-kernel-owner+w=401wt.eu-S1755446AbXIYM3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446AbXIYM3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 08:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbXIYM2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 08:28:55 -0400
Received: from mail.gmx.net ([213.165.64.20]:47039 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752261AbXIYM2y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 08:28:54 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19Ltfdss2VLNXfBvtk2aCLFdmn/Jfb49oHvvBcis6
	RhjzJ2+okxcQSE
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: vatsa@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925102855.GL26289@linux.vnet.ibm.com>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925091331.GA22905@elte.hu>
	 <20070925094440.GK26289@linux.vnet.ibm.com>
	 <20070925094040.GA28391@elte.hu> <20070925101044.GA923@elte.hu>
	 <20070925102855.GL26289@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 14:28:47 +0200
Message-Id: <1190723327.7112.5.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 15:58 +0530, Srivatsa Vaddagiri wrote:

> While I try recreating this myself, I wonder if this patch helps?

It didn't here, nor did tweaking root's share.  Booting with maxcpus=1,
I was unable to produce large latencies, but didn't try very many
things.

	-Mike

