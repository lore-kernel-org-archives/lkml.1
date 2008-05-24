Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbYEXAxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbYEXAxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 20:53:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbYEXAxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 20:53:43 -0400
Received: from relay1.sgi.com ([192.48.171.29]:47033 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752296AbYEXAxm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 20:53:42 -0400
Date: Fri, 23 May 2008 19:53:38 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: rdunlap@xenotime.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask
Message-Id: <20080523195338.f14336d7.pj@sgi.com>
In-Reply-To: <483763BE.40800@qualcomm.com>
References: <1211571995-17488-1-git-send-email-maxk@qualcomm.com>
	<20080523134702.e5fb9145.rdunlap@xenotime.net>
	<48372E2E.4020902@qualcomm.com>
	<20080523175447.e0c69591.pj@sgi.com>
	<483763BE.40800@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In other words I do not think it'll help you with the review.

I really do prefer to encourage people to include the Doc changes
in their submitted patches.  It does make it easier to review,
and the Doc changes are part of what needs to be reviewed.

I will do my best to complete my review, and I will most likely
ack this patch, once it is complete.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
