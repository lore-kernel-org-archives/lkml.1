Return-Path: <linux-kernel-owner+w=401wt.eu-S1758204AbYJKOU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204AbYJKOU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 10:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753474AbYJKOUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 10:20:50 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:48664 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbYJKOUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 10:20:48 -0400
Date: Sat, 11 Oct 2008 16:23:22 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Mark Brown <broonie@sirena.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] WM8350 support
Message-ID: <20081011142321.GD2712@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main> <1223648664.6814.323.camel@dell-desktop.example.com> <20081010143148.GB4823@localdomain> <20081010143832.GA1629@sirena.org.uk> <1223649928.6814.333.camel@dell-desktop.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223649928.6814.333.camel@dell-desktop.example.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Liam,

On Fri, Oct 10, 2008 at 03:45:28PM +0100, Liam Girdwood wrote:
> On Fri, 2008-10-10 at 15:38 +0100, Mark Brown wrote:
> > On Fri, Oct 10, 2008 at 04:31:49PM +0200, Samuel Ortiz wrote:
> > 
> > > Sorry guys, but I havent had time to look at those patches yet.
> > > Liam, when would be the last moment for me to ACK/NACK them ?
> > > I expect to be able to do so during this weekend.
> > 
> > I've done some updates since the original posting incorporating feedback
> > from Liam and an update for the regulator API - do you want me to repost
> > with those?  They're sitting in:
> > 
> > 	git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-lrg
> 
> Yes please.
I'm fine with Mark's mfd patches going upstream via your tree.
Please add an "Acked-by: Samuel Ortiz <sameo@openedhand.com>" line to all the
mfd patches (i.e. all of them except patch #13).

Thanks to Mark and you for those.

Cheers,
Samuel.


> Thanks
> 
> Liam
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
