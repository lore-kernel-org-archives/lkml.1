Return-Path: <linux-kernel-owner+w=401wt.eu-S1756036AbXI0LNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036AbXI0LNY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 07:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755021AbXI0LNR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 07:13:17 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:4052 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001AbXI0LNQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 07:13:16 -0400
Date: Thu, 27 Sep 2007 13:12:59 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927111259.GF15346@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com> <20070926112137.GA13876@elte.hu> <20070926112919.GN3337@deprecation.cyrius.com> <20070927094940.GA2894@elte.hu> <20070927105453.GE15346@deprecation.cyrius.com> <20070927105637.GA17936@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927105637.GA17936@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2007-09-27 12:56]:
> i'm curious by how much does CPU go down, and what's the output of
> iperf? (does it saturate full 100mbit network bandwidth)

I get about 94-95 Mbits/sec and CPU drops from 99% to about 82% (this
is with a 600 MHz ARM CPU).
-- 
Martin Michlmayr
http://www.cyrius.com/
