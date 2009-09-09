Return-Path: <linux-kernel-owner+w=401wt.eu-S1751191AbZIIEKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191AbZIIEKU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 00:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750778AbZIIEKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 00:10:20 -0400
Received: from mail.gmx.net ([213.165.64.20]:35484 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750721AbZIIEKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 00:10:19 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+HwFtTe6OHCPAw9PlVdvYfqj5C0PLVyMiFE7+KqN
	S1GymC9BzPnKj1
Subject: RE: question on sched-rt group allocation cap: sched_rt_runtime_us
From: Mike Galbraith <efault@gmx.de>
To: Anirban Sinha <ASinha@zeugmasystems.com>
Cc: Anirban Sinha <ani@anirban.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dario Faggioli <raistlin@linux.it>
In-Reply-To: <DDFD17CC94A9BD49A82147DDF7D545C501F0F6A8@exchange.ZeugmaSystems.local>
References: <dgRNo-3uc-5@gated-at.bofh.it> <dhb9j-1hp-5@gated-at.bofh.it>
	 <dhcf5-263-13@gated-at.bofh.it>
	 <36bbf267-be27-4c9e-b782-91ed32a1dfe9@g1g2000pra.googlegroups.com>
	 <1252218779.6126.17.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C54DC48B@exchange.ZeugmaSystems.local>
	 <217247FB-ED91-4A24-B698-71CEEFA58636@anirban.org>
	 <1252436788.6923.14.camel@marge.simson.net>
	 <DDFD17CC94A9BD49A82147DDF7D545C501F0F6A8@exchange.ZeugmaSystems.local>
Content-Type: text/plain
Date: Wed, 09 Sep 2009 06:10:17 +0200
Message-Id: <1252469417.6122.7.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 12:34 -0700, Anirban Sinha wrote:
> >Maybe.  Short term hack.  My current thoughts on the subject, after
> some
> >testing, is that the patchlet should just die, and pondering the larger
> >solution should happen.
> 
> Just curious, what is the larger solution?

That's what needs pondering :)

	-Mike

