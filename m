Return-Path: <linux-kernel-owner+w=401wt.eu-S1754240AbXDYVWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240AbXDYVWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 17:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbXDYVWb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 17:22:31 -0400
Received: from mail.z-net.ru ([89.113.80.10]:3660 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754238AbXDYVWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 17:22:30 -0400
Date: Thu, 26 Apr 2007 01:19:33 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 0/7] Battery class, external power framework, ds2760
	battery
Message-ID: <20070425211933.GA6964@zarina>
Reply-To: cbou@mail.ru
References: <20070425154820.GA27300@zarina> <20070425130501.29a72fa2.akpm@linux-foundation.org> <20070425210516.GA7078@zarina>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20070425210516.GA7078@zarina>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 01:05:16AM +0400, Anton Vorontsov wrote:
> On Wed, Apr 25, 2007 at 01:05:01PM -0700, Andrew Morton wrote:
> > On Wed, 25 Apr 2007 19:48:20 +0400 Anton Vorontsov <cbou@mail.ru> wrote:
> > 
> > > Andrew, would you please merge these patches into -mm? They're against
> > > today's Linus git tree.
> > 
> > Not for a while, sorry.  We already have enough material queued for 2.6.22
> > and a lot of it is broken.  So I am concentrating on fixing the remaining
> > bugs in 2.6.21 and getting some of the new bugs we have prepared for 2.6.22
> > fixed up.
> 
> Pity. Not trying to insist too hard, but this battery stuff can not break
> anything pre-existing in kernel. Also it's proven to work at least on five
> different embedded devices PXA2xx and S3C (HP iPaqs h2200, rx3000, h5550
> and hx4700), with two battery types. Plus I believe that this battery

Forgot h4000. Now there are five. ;-)

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
