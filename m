Return-Path: <linux-kernel-owner+w=401wt.eu-S1755157Ab0A2CDG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0A2CDG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 21:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755145Ab0A2CDA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 21:03:00 -0500
Received: from gate.crashing.org ([63.228.1.57]:49812 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755121Ab0A2CC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 21:02:59 -0500
Subject: Re: [PATCHv2 2/2] powerpc: implement arch_scale_smt_power for
 Power7
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joel Schopp <jschopp@austin.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, ego@in.ibm.com,
       linuxppc-dev@lists.ozlabs.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B621213.2010805@austin.ibm.com>
References: <1264017638.5717.121.camel@jschopp-laptop>
	 <1264017847.5717.132.camel@jschopp-laptop>
	 <1264548495.12239.56.camel@jschopp-laptop>
	 <1264553577.3601.144.camel@pasglop>  <4B621213.2010805@austin.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 29 Jan 2010 12:23:44 +1100
Message-ID: <1264728224.20211.35.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I've tested it with manually offlined threads and it behaves as I'd like 
> it to.

Which is ? IE. I'm happy that you like how it behaves, but I'd like to u
understand how that is so I can make sure I'm also happy with it :-)

Cheers,
Ben.


