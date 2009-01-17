Return-Path: <linux-kernel-owner+w=401wt.eu-S1759699AbZAQNXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699AbZAQNXS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 08:23:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757422AbZAQNW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 08:22:59 -0500
Received: from mail.gmx.net ([213.165.64.20]:60700 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757408AbZAQNW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 08:22:59 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/JXqwIT7vJdq0/EwKsJqvfVhZreh6zJBscsPhrhj
	sNNlyE8SceIz/G
Subject: Re: [git pull] scheduler fixes
From: Mike Galbraith <efault@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: a.p.zijlstra@chello.nl, mingo@elte.hu, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090117044316.bda7d0bd.akpm@linux-foundation.org>
References: <20090111144305.GA7154@elte.hu>
	 <20090114121521.197dfc5e.akpm@linux-foundation.org>
	 <1231964647.14825.59.camel@laptop>
	 <20090116204049.f4d6ef1c.akpm@linux-foundation.org>
	 <1232173776.7073.21.camel@marge.simson.net>
	 <1232186054.6813.48.camel@marge.simson.net>
	 <1232186877.14073.59.camel@laptop>
	 <1232188484.6813.85.camel@marge.simson.net>
	 <1232193617.14073.67.camel@laptop>
	 <1232194752.6273.5.camel@marge.simson.net>
	 <20090117044316.bda7d0bd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Sat, 17 Jan 2009 14:22:54 +0100
Message-Id: <1232198574.16303.8.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.71
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-01-17 at 04:43 -0800, Andrew Morton wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=12465 just popped up - another
> scheduler regression.  It has been bisected.

Seems pretty clear.  I'd suggest reverting it.

	-Mike

