Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1757514AbYLPVwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbYLPVwo (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 16:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753032AbYLPVwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 16:52:34 -0500
Received: from ozlabs.org ([203.10.76.45]:40849 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248AbYLPVwe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 16:52:34 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18760.8982.774791.448768@cargo.ozlabs.ibm.com>
Date: Wed, 17 Dec 2008 08:52:22 +1100
From: Paul Mackerras <paulus@samba.org>
To: Vince Weaver <vince@deater.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephane Eranian <eranian@googlemail.com>,
        Eric Dumazet <dada1@cosmosbay.com>,
        Robert Richter <robert.richter@amd.com>,
        Arjan van de Ven <arjan@infradead.org>, Peter Anvin <hpa@zytor.com>,
        "David S. Miller" <davem@davemloft.net>,
        perfctr-devel@lists.sourceforge.net
Subject: Re: [patch] Performance Counters for Linux, v4
In-Reply-To: <Pine.LNX.4.64.0812161149430.6141@pianoman.cluster.toy>
References: <20081214212829.GA9435@elte.hu>
	<Pine.LNX.4.64.0812151243130.2773@pianoman.cluster.toy>
	<18758.53072.197695.277198@cargo.ozlabs.ibm.com>
	<1229438579.7025.21.camel@twins>
	<Pine.LNX.4.64.0812161149430.6141@pianoman.cluster.toy>
X-Mailer: VM 8.0.9 under Emacs 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince Weaver writes:
> 
> > On Tue, 2008-12-16 at 08:42 +1100, Paul Mackerras wrote:
> > Furthermore, I think output of tools such as time and now timec are most
> > relevant when compared between runs - that is, the change in values
> > between runs, not the absolute values as such. At least, that's what I
> > usually do:

Just for the record, I didn't write the quoted paragraph, Peter
Zijlstra did.

Paul.
