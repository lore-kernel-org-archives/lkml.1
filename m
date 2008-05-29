Return-Path: <linux-kernel-owner+w=401wt.eu-S1754896AbYE3DWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896AbYE3DWW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 23:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbYE3DWM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 23:22:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54085 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbYE3DWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 23:22:10 -0400
Message-ID: <483F3EC4.5050700@zytor.com>
Date: Thu, 29 May 2008 16:39:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jeff Garzik <jeff@garzik.org>, David Woodhouse <dwmw2@infradead.org>,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       David Miller <davem@davemloft.net>
Subject: Re: [Ksummit-2008-discuss] RFC: Moving firmware blobs out of the
 kernel.
References: <1211995212.3445.52.camel@localhost.localdomain>	 <20080528.225826.40264516.davem@davemloft.net>	 <1212041839.8888.38.camel@pasglop> <20080529124548.GC8065@mit.edu>	 <1212077700.26088.83.camel@shinybook.infradead.org>	 <483F002E.5060002@garzik.org> <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212095864.24826.2.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> 
> I certainly agree, pushing more and more into initrd just annoys the
> hell out of me.
> 
> I'd argue to include everything needed to build (and esp cross build) an
> initrd into the kernel - up until that point initrds are useless.
> 

I tried to push for that two years ago.  I'd be more than happy to pull 
that out of the freezer.

	-hpa
