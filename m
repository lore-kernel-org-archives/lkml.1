Return-Path: <linux-kernel-owner+w=401wt.eu-S1753724AbZGVLxj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724AbZGVLxj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 07:53:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZGVLxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 07:53:38 -0400
Received: from mail-a04.ithnet.com ([217.64.83.99]:52233 "HELO ithnet.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751706AbZGVLxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 07:53:38 -0400
X-Sender-Authentication: net64
Date: Wed, 22 Jul 2009 13:53:33 +0200
From: Stephan von Krawczynski <skraw@ithnet.com>
To: David Rientjes <rientjes@google.com>
Cc: Jesse Brandeburg <jesse.brandeburg@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: What to do with this message (2.6.30.1) ?
Message-Id: <20090722135333.56286536.skraw@ithnet.com>
In-Reply-To: <alpine.DEB.2.00.0907151323170.22582@chino.kir.corp.google.com>
References: <20090713134621.124aa18e.skraw@ithnet.com>
	<4807377b0907132240g6f74c9cbnf1302d354a0e0a72@mail.gmail.com>
	<alpine.DEB.2.00.0907132247001.8784@chino.kir.corp.google.com>
	<20090715084754.36ff73bf.skraw@ithnet.com>
	<alpine.DEB.2.00.0907150115190.14393@chino.kir.corp.google.com>
	<20090715113740.334309dd.skraw@ithnet.com>
	<alpine.DEB.2.00.0907151323170.22582@chino.kir.corp.google.com>
Organization: ith Kommunikationstechnik GmbH
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.9; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jul 2009 13:24:08 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 15 Jul 2009, Stephan von Krawczynski wrote:
> 
> > > If you have some additional time, it would also be helpful to get a 
> > > bisection of when the problem started occurring (it appears to be sometime 
> > > between 2.6.29 and 2.6.30).
> > 
> > Do you know what version should definitely be not affected? I can check one
> > kernel version per day, can you name a list which versions to check out? 
> > 
> 
> To my knowledge, this issue was never reported on 2.6.29, so that should 
> be a sane starting point.

Last result: 2.6.30.2 has the same problem.
Can I help you in any way to solve the issue?
I can check patches or other ideas if needed.

-- 
Regards,
Stephan

