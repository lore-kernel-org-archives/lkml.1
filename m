Return-Path: <linux-kernel-owner+w=401wt.eu-S1756564AbZCJWJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbZCJWJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 18:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753156AbZCJWJI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 18:09:08 -0400
Received: from gate.crashing.org ([63.228.1.57]:56361 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754870AbZCJWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 18:09:07 -0400
Subject: Re: commit "radeonfb: Fix resume from D3Cold on some platforms"
 breaks resume from RAM on PowerBook
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Gaudenz Steinlin <gaudenz@soziologie.ch>
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20090310213027.GB6272@soziologie.ch>
References: <20090304083859.GB6889@soziologie.ch>
	 <1236219920.7260.6.camel@pasglop> <20090305125919.GA5474@soziologie.ch>
	 <1236318629.7260.120.camel@pasglop> <20090306090906.GA5183@soziologie.ch>
	 <1236333440.7260.136.camel@pasglop> <20090306114149.GA5371@soziologie.ch>
	 <1236638264.7260.192.camel@pasglop>  <20090310213027.GB6272@soziologie.ch>
Content-Type: text/plain
Date: Wed, 11 Mar 2009 09:07:46 +1100
Message-Id: <1236722866.7086.12.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-10 at 22:30 +0100, Gaudenz Steinlin wrote:
> Are you still interested in these tests after that disabling the early
> resume hack fixed things? I can try my best to test and add printk's
> but
> it will probably take some time because I can't constantly reboot my
> computer and still do some usefull work...
> 
No thanks, I think the initial test with early resume was flawed due to
something like having cpufreq disabled.

Cheers,
Ben.


