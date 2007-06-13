Return-Path: <linux-kernel-owner+w=401wt.eu-S1758053AbXFMMUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053AbXFMMUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 08:20:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbXFMMUX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 08:20:23 -0400
Received: from mailhub.hp.com ([192.151.27.10]:42666 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbXFMMUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 08:20:22 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Wed, 13 Jun 2007 08:20:19 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-ia64@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ia64: Scalability improvement of gettimeofday with jitter compensation
Message-ID: <20070613122019.GI11999@localhost>
References: <466E0FA4.2040405@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <466E0FA4.2040405@jp.fujitsu.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto wrote:	[Mon Jun 11 2007, 11:14:44PM EDT]
[snip]
I didn't examine your patch closely but did notice modification to the
time interpolator. I'll attempt to examine your patch with more scrutiny
in the next few days.

I will be pushing Peter Keilty's clocksource ia64 patches within the next
week or so.  At that time I'll ask for inclusion into -mm. Please see:
http://marc.info/?t=117881585500001&r=1&w=2
You'll notice that the time interpolator is removed.

BTW. Peter is no longer with HP. He participated in the Employee Early
Retirement program and left May 31.

thanks,

bob
