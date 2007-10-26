Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbXJZVsR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbXJZVsR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:48:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755043AbXJZVsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:48:03 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50160 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753539AbXJZVsB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:48:01 -0400
Message-ID: <4722608E.3000405@garzik.org>
Date: Fri, 26 Oct 2007 17:47:58 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com
Subject: Re: [PATCH 7/9] irq-remove: scsi driver trivial
References: <20071019075443.GA6407@havoc.gtf.org>	<20071019075808.GH6407@havoc.gtf.org>	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3D54D@otce2k301.adaptec.com> <20071026143525.b9218ed7.akpm@linux-foundation.org>
In-Reply-To: <20071026143525.b9218ed7.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> That was a goofup.  I proposed that we should add a #define
> TWO_ARG_IRQ_HANDLERS (or whatever) and I think I actually wrote the patch,
> but it got lost.
> 
> I agree it would be a kind thing to do in this case.


Yep, I was thinking that including

	#define IRQ_HANDLER_V3

would be a good idea.

	Jeff


