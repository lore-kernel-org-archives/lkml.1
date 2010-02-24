Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0BXKAc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:00:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755651Ab0BXKAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:00:31 -0500
Date: Wed, 24 Feb 2010 11:00:26 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Paul Menage <menage@google.com>
Cc: leemgs1@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: Update the cpuset flag file from old name from
  new name correctly.
In-Reply-To: <6599ad831002231645g7a53f7bbkda4c7d3cfad2d71@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1002241100060.16183@twin.jikos.cz>
References: <1266838378.3962.10.camel@centos51> <6599ad831002231645g7a53f7bbkda4c7d3cfad2d71@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Feb 2010, Paul Menage wrote:

> > Dear Jiri Kosina,
> >
> > This is a trivial patch for cpuset feature.
> > Current document file for cpuset is still not updated.
> > So, I made this patch that updated cpusets.txt based on linux-2.6.33-rc8.
> >
> > Regards,
> > Geunsik Lim.
> >
> >
> > >From 1fedbe5698e4bc892e795d68da826320f9e1fa1b Mon Sep 17 00:00:00 2001
> > From: GeunSik,Lim <leemgs1@gmail.com>
> > Date: Mon, 22 Feb 2010 20:05:03 +0900
> > Subject: [PATCH] cpuset: Update the cpuset flag file from old name from new name.
> >
> > This patch is for modifying with correct cuset flag file.
> > We need to update current manual for cpuset.
> > For example,
> > before) cpus, cpu_exclusive, mems
> > after ) cpuset.cpus, cpuset.cpu_exclusive, cpuset.mems
> >
> > Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
> 
> Looks reasonable, thanks.
> 
> There are some bits in the docs where the "cpuset." prefix isn't
> really needed, but I guess it's better to be consistent.
> 
> Acked-by: Paul Menage <menage@google.com>

Applied, thanks guys.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

