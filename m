Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbZDOGYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbZDOGYr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:24:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZDOGYi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:24:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:35043 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751408AbZDOGYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:24:38 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18g2w4hHrAgR9qQO1csgwZvKVo7sbs1I9Ve0B0+gh
	2PlA5X0CFnSYla
Subject: Re: 2.6.30.git: USB storage (usbstick) automount woes - bisected
From: Mike Galbraith <efault@gmx.de>
To: alan-jenkins@tuffmail.co.uk
Cc: Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <9b2b86520904090253m5afada22jd32d272da1b733fc@mail.gmail.com>
References: <1239269217.16653.14.camel@marge.simson.net>
	 <9b2b86520904090253m5afada22jd32d272da1b733fc@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 08:24:29 +0200
Message-Id: <1239776669.6120.1.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-04-09 at 10:53 +0100, Alan Jenkins wrote:
> On 4/9/09, Mike Galbraith <efault@gmx.de> wrote:
> > Greetings,
> >
> > Plugging a USB stick after the first big .30 pull (8e0ee43..c31f403) no
> > longer detects/automounts on my opensuse 11.0 x86_64 box.  Bisection
> > fingered e6e244b6cb1f70e7109381626293cd40a8334ed3.
> 
> Alan Stern posted a test patch here:
> <http://lkml.org/lkml/2009/4/8/735>.  I can confirm that this fixes
> the problem.

Ping.

(patchlet missed the boat for rc2)

