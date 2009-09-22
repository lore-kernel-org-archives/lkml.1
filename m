Return-Path: <linux-kernel-owner+w=401wt.eu-S1755422AbZIVIBJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755422AbZIVIBJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 04:01:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZIVIBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 04:01:06 -0400
Received: from gate.crashing.org ([63.228.1.57]:48849 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754579AbZIVIBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 04:01:04 -0400
Subject: Re: [PATCH] perf_event, powerpc: Fix compilation after big
 perf_counter rename
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       "David S. Miller" <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20090922072834.GA25470@elte.hu>
References: <19128.4280.813369.589704@cargo.ozlabs.ibm.com>
	 <1253584591.7103.197.camel@pasglop>  <20090922072834.GA25470@elte.hu>
Content-Type: text/plain
Date: Tue, 22 Sep 2009 18:00:15 +1000
Message-Id: <1253606415.7103.216.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-22 at 09:28 +0200, Ingo Molnar wrote:
> 
> Nevertheless you are right that i should have caught this particular 
> PowerPC build bug - i missed it - sorry about that!
> 
Allright. Well, to help in general, we are setting up a build-bot
here too that will build -tip HEAD for at least powerpc daily with
a few configs too.

Cheers,
Ben.


