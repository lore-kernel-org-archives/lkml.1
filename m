Return-Path: <linux-kernel-owner+w=401wt.eu-S1946607AbXBIQVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946607AbXBIQVZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 11:21:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946608AbXBIQVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 11:21:25 -0500
Received: from www.osadl.org ([213.239.205.134]:52209 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946607AbXBIQVY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 11:21:24 -0500
Date: Fri, 9 Feb 2007 17:21:21 +0100
From: Benedikt Spranger <b.spranger@linutronix.de>
To: John <linux.kernel@free.fr>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@timesys.com>,
       a.p.zijlstra@chello.nl, mingo@elte.hu, johnstul@us.ibm.com,
       akpm@osdl.org
Subject: Re: One-shot high-resolution POSIX timer periodically late
Message-Id: <20070209172121.42cb15d2.b.spranger@linutronix.de>
In-Reply-To: <45CC9257.8080806@free.fr>
References: <fa.4zD54Ie6Ozt0P4YqQSicS+XzXGw@ifi.uio.no>
	<fa.G+/T32f2o1M3+YGLca/O8NaAQyY@ifi.uio.no>
	<fa.6Ua8xjNfLKQEZZgDsoJgPMyww4g@ifi.uio.no>
	<fa.yQlV+WU0TgrJTVqjopa01tgCnT0@ifi.uio.no>
	<fa.ucVrLJ1Lh6FjdBHRglsIUc8/evk@ifi.uio.no>
	<fa.Id9oufyELrVbe5Wb8SRakwC0V50@ifi.uio.no>
	<45C75D2D.9010506@free.fr>
	<1170747081.4672.11.camel@twins>
	<45C9A8FE.3090705@free.fr>
	<1170955962.3646.51.camel@chaos>
	<45CC9257.8080806@free.fr>
Organization: Linutronix
X-Mailer: Sylpheed version 2.3.0beta5 (GTK+ 2.10.7; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Feb 2007 16:25:11 +0100
John <linux.kernel@free.fr> wrote:

> By the way, I have a question: when I compile glibc for this system,
> should I compile it against the vanilla 2.6.20 includes, or against
> the patched 2.6.20-rt includes?

That shouldn't make a difference. All of the
kernel/glibc-interface related parts are in vanilla now.

Bene
