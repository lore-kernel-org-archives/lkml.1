Return-Path: <linux-kernel-owner+w=401wt.eu-S1757280AbYDITfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757280AbYDITfY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 15:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753715AbYDITfL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 15:35:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:32794 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753523AbYDITfK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 15:35:10 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18bo5MFOyYbU6OaBoTfZOu+amwS3gxsI7+TyyhaOB
	hn5UfFRanLuSih
Date: Wed, 9 Apr 2008 21:35:04 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
X-X-Sender: lyakh@axis700.grange
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <Uwe.Kleine-Koenig@digi.com>
cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: gpio patches in mmotm
In-Reply-To: <20080409063530.GA17538@digi.com>
Message-ID: <Pine.LNX.4.64.0804092133160.7315@axis700.grange>
References: <20080317173134.GA27282@digi.com> <Pine.LNX.4.64.0803171915020.8640@axis700.grange>
 <20080318160316.GA31588@digi.com> <Pine.LNX.4.64.0803181717240.5022@axis700.grange>
 <20080408060230.GA22071@digi.com> <Pine.LNX.4.64.0804080812420.3556@axis700.grange>
 <20080408093305.GA8141@digi.com> <Pine.LNX.4.64.0804081227360.4987@axis700.grange>
 <20080409063530.GA17538@digi.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Apr 2008, Uwe Kleine-König wrote:

> Hello Guennadi,
> 
> Guennadi Liakhovetski wrote:
> >                      My original proposal was to introduce just one 
> > NO_GPIO macro to test against, however, David nicely managed to persuade 
> > me, that the gpio_is_valid approach is better. Unfortunately, I cannot 
> > argument as nicely as he did, maybe looking through his emails in LKML 
> > archives will help you:-)
> I'm unable to find these mails.  (Using gmane, looking for mails by
> David matching gpio_is_valid, the oldest post I can find is
> http://article.gmane.org/gmane.linux.kernel/637654.)
> 
> Can you please point out the discussion in the archives?

See also

http://marc.info/?t=120179335100005&r=1&w=2
http://marc.info/?t=120267097400002&r=1&w=2

Thanks
Guennadi
---
Guennadi Liakhovetski
