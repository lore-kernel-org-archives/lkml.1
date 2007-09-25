Return-Path: <linux-kernel-owner+w=401wt.eu-S1752377AbXIYJRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377AbXIYJRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 05:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751326AbXIYJRm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 05:17:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:53321 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751296AbXIYJRl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 05:17:41 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+yFl0Do/ayMlgyrv360ftGccUTV8bR/vOmo68ePt
	WlSsujiK2oR1uw
Subject: Re: [git] CFS-devel, latest code
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070925091331.GA22905@elte.hu>
References: <20070924214537.GA18980@elte.hu>
	 <1190700652.6482.7.camel@Homer.simpson.net>
	 <1190705759.11910.10.camel@Homer.simpson.net>
	 <1190709207.11226.6.camel@Homer.simpson.net>
	 <20070925091331.GA22905@elte.hu>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 11:17:38 +0200
Message-Id: <1190711858.13861.10.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-09-25 at 11:13 +0200, Ingo Molnar wrote:

> > [...] Latencies of up to 336ms hit me during the recompile (make -j3), 
> > with nothing else running. Since reboot, latencies are, so far, very 
> > very nice. [...]
> 
> 'very very nice' == 'best ever' ? :-)

Yes.  Very VERY nice feel.

	-Mike

