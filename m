Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbYJETPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbYJETPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755884AbYJETPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 15:15:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:48986 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755551AbYJETPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 15:15:11 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: 2.6.27-rc8+ - first impressions
Date: Sun, 5 Oct 2008 21:19:13 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <20081005183603.GA3263@amd.corenet.prv> <200810052059.49942.rjw@sisk.pl> <20081005190658.GC3263@amd.corenet.prv>
In-Reply-To: <20081005190658.GC3263@amd.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810052119.13881.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> On Sun, Oct 05, 2008 at 08:59:49PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 5 of October 2008, Dmitry Torokhov wrote:
> > > Hi,
> > > 
> > > Lats night I loaded 2.6.27-rc8-tip for the first time on my AMD Turion
> > > 64 laptop that is normally runs with Fedora distribution kernel.
> > > Compared to 2.6.25 the thing is broken - hdparm reports about 3MB/sec
> > > speed, fans are constantly on, everything seems sluggish.
> > > 
> > > Booting with hpet=force (HPET is disabled in BIOS) hangs the box
> > > somewhere in tty_init.
> > 
> > Is that an HP box, by chance?
> > 
> 
> Yeah, HP nx6115.

Oh well.

Please send me the output of dmidecode from it.

Thanks,
Rafael
