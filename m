Return-Path: <linux-kernel-owner+w=401wt.eu-S1422888AbXDYWrs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422888AbXDYWrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 18:47:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423399AbXDYWrs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 18:47:48 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:49354 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422888AbXDYWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 18:47:47 -0400
Date: Wed, 25 Apr 2007 15:47:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: cbou@mail.ru
Cc: linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [PATCH 0/7] Battery class, external power framework, ds2760
 battery
Message-Id: <20070425154736.8c282208.akpm@linux-foundation.org>
In-Reply-To: <20070425210516.GA7078@zarina>
References: <20070425154820.GA27300@zarina>
	<20070425130501.29a72fa2.akpm@linux-foundation.org>
	<20070425210516.GA7078@zarina>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 01:05:16 +0400 Anton Vorontsov <cbou@mail.ru> wrote:

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
> anything pre-existing in kernel.

That helps.

>  Also it's proven to work at least on five
> different embedded devices PXA2xx and S3C (HP iPaqs h2200, rx3000, h5550
> and hx4700), with two battery types. Plus I believe that this battery
> class more than suitable for OLPC guys (battery-2.6 tree).
> 
> Anyway, maybe it's even better if we'll boil battery stuff a *bit* more.
> 
> Also you didn't [directly] answered how long exactly we should wait,
> should we come back after 2.6.21 or 2.6.22 release? In later case it's a
> bit too long, isn't it?

I'm not sure yet.  I've saved away these patches.  They seemed to get a
decent review - let's aim for 2.6.22.

