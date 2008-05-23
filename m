Return-Path: <linux-kernel-owner+w=401wt.eu-S1760582AbYEWWy7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582AbYEWWy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2008 18:54:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758912AbYEWWyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 May 2008 18:54:52 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33224 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753733AbYEWWyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2008 18:54:51 -0400
Date: Fri, 23 May 2008 17:54:47 -0500
From: Paul Jackson <pj@sgi.com>
To: Max Krasnyanskiy <maxk@qualcomm.com>
Cc: rdunlap@xenotime.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de
Subject: Re: [PATCH] [genirq] Expose default irq affinity mask
Message-Id: <20080523175447.e0c69591.pj@sgi.com>
In-Reply-To: <48372E2E.4020902@qualcomm.com>
References: <1211571995-17488-1-git-send-email-maxk@qualcomm.com>
	<20080523134702.e5fb9145.rdunlap@xenotime.net>
	<48372E2E.4020902@qualcomm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max, replying to Randy:
> > Documentation, perhaps an update to Documentation/filesystems/proc.txt ?
> Absolutely. I wanted to see if it gets accepted first.

For new features such as this, documentation is helpful in reviewing.

(For me at least, documentation is even helpful in -writing- the code,
as I find that if I can't explain something in words clearly and
accurately, then my code is probably confused as well.  However, I'm
obviously weird, and not just in this regard.)

>From what I can tell, it's ok.  I look forward to seeing the Documentation,
and will review it again at that time.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
