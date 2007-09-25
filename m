Return-Path: <linux-kernel-owner+w=401wt.eu-S1761890AbXIYANT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761890AbXIYANT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 20:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756618AbXIYANK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 20:13:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:14085 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbXIYANJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 20:13:09 -0400
Subject: Re: [git] CFS-devel, latest code
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Mike Galbraith <efault@gmx.de>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20070924214537.GA18980@elte.hu>
References: <20070924214537.GA18980@elte.hu>
Content-Type: text/plain
Date: Mon, 24 Sep 2007 17:08:02 -0700
Message-Id: <1190678882.2634.1.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-09-24 at 23:45 +0200, Ingo Molnar wrote:
> Lots of scheduler updates in the past few days, done by many people. 
> Most importantly, the SMP latency problems reported and debugged by
> Mike 
> Galbraith should be fixed for good now. 

Does this have anything to do with idle balancing ? I noticed some
fairly large latencies in that code in 2.6.23-rc's ..

Daniel

