Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370AbZIHJ0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbZIHJ0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 05:26:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbZIHJ0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 05:26:17 -0400
Received: from mail.gmx.net ([213.165.64.20]:37426 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754125AbZIHJ0Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 05:26:16 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18y9hcwwnEyIoYy2CFAB6oyqmpUFGlzd7+4uclcHm
	Nuo8FjFB1seTO/
Subject: Re: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Anirban Sinha <ani@anirban.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dario Faggioli <raistlin@linux.it>,
       Anirban Sinha <ASinha@zeugmasystems.com>
In-Reply-To: <7D542E15-CEA4-43CD-AB4E-48ED103EE7B9@anirban.org>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC483@exchange.ZeugmaSystems.local>
	 <1252306486.7423.72.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC489@exchange.ZeugmaSystems.local>
	 <7D542E15-CEA4-43CD-AB4E-48ED103EE7B9@anirban.org>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 11:26:12 +0200
Message-Id: <1252401972.18991.41.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 00:10 -0700, Anirban Sinha wrote:

> > I tested tip (v2.6.31-rc9-1357-ge6a3cd0) with a little perturbation
> > measurement proglet on an isolated Q6600 core.
> 
> 
> Thanks Mike. Is this on a single core machine (or one core carved out  
> of N)?  We may have some newer patches missing from the 2.6.26 kernel  
> that fixes some accounting bugs. I will do a review and rerun the test  
> after applying the upstream patches.

Q6600 is a quad, test was 1 carved out of 4 (thought i said that).

	-Mike

