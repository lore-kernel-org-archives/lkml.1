Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbXI0Kz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbXI0Kz1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 06:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755753AbXI0KzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 06:55:11 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:2112 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755860AbXI0KzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 06:55:10 -0400
Date: Thu, 27 Sep 2007 12:54:53 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: Network slowdown due to CFS
Message-ID: <20070927105453.GE15346@deprecation.cyrius.com>
References: <20070926085202.GE3337@deprecation.cyrius.com> <1190802208.7318.5.camel@Homer.simpson.net> <20070926104814.GM3337@deprecation.cyrius.com> <20070926112137.GA13876@elte.hu> <20070926112919.GN3337@deprecation.cyrius.com> <20070927094940.GA2894@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070927094940.GA2894@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2007-09-27 11:49]:
> Martin, could you check the iperf patch below instead of the yield
> patch - does it solve the iperf performance problem equally well,
> and does CPU utilization drop for you too?

Yes, it works and CPU goes down too.
-- 
Martin Michlmayr
http://www.cyrius.com/
