Return-Path: <linux-kernel-owner+w=401wt.eu-S1754198AbZFELKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198AbZFELKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 07:10:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753234AbZFELKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 07:10:08 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:43951 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651AbZFELKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 07:10:06 -0400
Date: Fri, 5 Jun 2009 13:08:19 +0200
From: Harald Welte <HaraldWelte@viatech.com>
To: Dave Jones <davej@redhat.com>, "Michael S. Zick" <lkml@morethan.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Duane Griffin <duaneg@dghda.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: VIA CPU PCI cache line size (Re: Linux 2.6.30-rc8 [also: VIA
	Support])
Message-ID: <20090605110819.GI4421@prithivi.gnumonks.org>
References: <alpine.LFD.2.01.0906022055030.4880@localhost.localdomain> <20090604214301.GB20822@redhat.com> <200906041700.17852.lkml@morethan.org> <200906041826.42856.lkml@morethan.org> <20090605001510.GA2479@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090605001510.GA2479@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:15:10PM -0400, Dave Jones wrote:

> I meant just doing something like this..
> 
> (untested)
> 
> I'm not sure if the clflush_size==0 case can happen, which is why
> I left the fallback.  Maybe on ancient cpus?

this patch looks fine with me.  I didn't do any testing yet either, though.

-- 
- Harald Welte <HaraldWelte@viatech.com>	    http://linux.via.com.tw/
============================================================================
VIA Free and Open Source Software Liaison
