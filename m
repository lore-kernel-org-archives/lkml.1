Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbYJET1v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbYJET1v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:27:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755915AbYJET1n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:27:43 -0400
Received: from www.tglx.de ([62.245.132.106]:60193 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755522AbYJET1m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:27:42 -0400
Date: Sun, 5 Oct 2008 21:27:20 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.27-rc8+ - first impressions
In-Reply-To: <200810052119.13881.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0810052126132.3398@apollo>
References: <20081005183603.GA3263@amd.corenet.prv> <200810052059.49942.rjw@sisk.pl> <20081005190658.GC3263@amd.corenet.prv> <200810052119.13881.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 5 Oct 2008, Rafael J. Wysocki wrote:
> On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > > Hi,
> > > > 
> > > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > > speed, fans are constantly on, everything seems sluggish.
> > > > 
> > > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > > somewhere in tty_init.
> > > 
> > > Is that an HP box, by chance?
> > > 
> > 
> > Yeah, HP nx6115.
> 
> Oh well.
> 
> Please send me the output of dmidecode from it.

Please send me bootlog (output of dmesg) and output of "cat /proc/timer_list"

Thanks,

	tglx
