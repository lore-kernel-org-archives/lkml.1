Return-Path: <linux-kernel-owner+w=401wt.eu-S934379AbZDIOqn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934379AbZDIOqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 10:46:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934059AbZDIOqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 10:46:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51940 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933928AbZDIOqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 10:46:15 -0400
Date: Thu, 9 Apr 2009 10:46:12 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, linux-parisc@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: 2.6.30-rc1: parisc: system hangs on boot at __schedule()
Message-ID: <20090409144611.GH7372@bombadil.infradead.org>
References: <a4423d670904080603w50face2fl87cd16bd7967cb5d@mail.gmail.com> <20090408220921.GF7372@bombadil.infradead.org> <a4423d670904090146w2937bf15le2afb5dfad718f0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670904090146w2937bf15le2afb5dfad718f0e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 09, 2009 at 12:46:15PM +0400, Alexander Beregalov wrote:
> 2009/4/9 Kyle McMartin <kyle@mcmartin.ca>:
> > On Wed, Apr 08, 2009 at 05:03:04PM +0400, Alexander Beregalov wrote:
> >> Hi
> >>
> >> Machine is HP j6000.
> >> CPU(s): 2 x PA8700 (PCX-W2) at 750.000000 MHz
> >>
> >> gcc version 4.3.3 (Gentoo 4.3.3-r2 p1.1, pie-10.1.5)
> >>
> >>
> >> Machine hangs before starting rc scripts, but SysRq and C-A-Del work.
> >>
> >> All tasks are at __schedule+0x268/0x7bc:
> >>
> >
> > .config?
> 
> Sorry, attached.

Thanks, I swapped disks into my j6700 and will try to reproduce.

regards, Kyle
