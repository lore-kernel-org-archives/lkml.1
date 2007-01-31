Return-Path: <linux-kernel-owner+w=401wt.eu-S1161051AbXAaV4Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161051AbXAaV4Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 16:56:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161054AbXAaV4Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 16:56:16 -0500
Received: from 1wt.eu ([62.212.114.60]:2209 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161051AbXAaV4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 16:56:15 -0500
Date: Wed, 31 Jan 2007 22:56:03 +0100
From: Willy Tarreau <w@1wt.eu>
To: Diego Calleja <diegocg@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070131215603.GD24090@1wt.eu>
References: <20070130012904.GA9617@kroah.com> <Pine.LNX.4.61.0701301151350.23321@yvahk01.tjqt.qr> <20070130191405.GI20642@kroah.com> <Pine.LNX.4.61.0701302028440.13737@yvahk01.tjqt.qr> <20070130212334.2a042fdf.diegocg@gmail.com> <20070131211312.GR5599@lug-owl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070131211312.GR5599@lug-owl.de>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 31, 2007 at 10:13:12PM +0100, Jan-Benedict Glaw wrote:
> On Tue, 2007-01-30 21:23:34 +0100, Diego Calleja <diegocg@gmail.com> wrote:
> > El Tue, 30 Jan 2007 20:31:01 +0100 (MET), Jan Engelhardt <jengelh@linux01.gwdg.de> escribió:
> > > Don't they claim 50+? Already browsing 
> > > ftp://ftp.de.netbsd.org/pub/NetBSD/NetBSD-3.1 gives more than 2 
> > > screenfuls [à 25].
> > 
> > Sure, Linux doesn't support vax and the like, but it does support lots of
> > architectures that matter. In  http://netbsd.org/Ports/#ports-by-cpu there's a
> 
> Well, there *is* a 2.6.x based VAX port, though it needs some updates
> to incorporate the last few months of upstream development. But NetBSD
> still does better hardware support.

a few years ago, I installed NetBSD 1.6 on my VLC4000. It hanged every now
and then (several times a month). I finally tried OpenBSD 3.1 and it never
hanged nor crashed since. It's been running 3.7 fine from its release till
now. I don't know if NetBSD's VAX support has stabilized now, but I thought
it might be of interest to you to be aware that at least another OS runs
fine on this hardware.

Best regards,
Willy

