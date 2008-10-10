Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYJJOjG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYJJOjG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:39:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758964AbYJJOix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:38:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:41173 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757487AbYJJOiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:38:52 -0400
Subject: Re: [PATCH 0/13] WM8350 support
From: Liam Girdwood <lrg@kernel.org>
To: Samuel Ortiz <sameo@openedhand.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081010143148.GB4823@localdomain>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main>
	 <1223648664.6814.323.camel@dell-desktop.example.com>
	 <20081010143148.GB4823@localdomain>
Content-Type: text/plain
Date: Fri, 10 Oct 2008 15:38:45 +0100
Message-Id: <1223649525.6814.331.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-10 at 16:31 +0200, Samuel Ortiz wrote:
> On Fri, Oct 10, 2008 at 03:24:24PM +0100, Liam Girdwood wrote:
> > On Mon, 2008-10-06 at 13:32 +0100, Mark Brown wrote:
> > > These patches against the regulator tree add initial support for the
> > > WM8350, a multi-function device with several subsystems targetted at
> > > embedded systems.  This series adds a core driver providing device acess
> > > under drivers/mfd and support for the PMIC functionality of the device
> > > via the regulator API.  Due to their use in the core some definitions
> > > for other parts of the device are also included - drivers for these will
> > > follow.
> > > 
> > > All the WM8350 drivers submitted here were originally written by Liam
> > > Girdwood with some updates from me for submission to mainline.
> > > 
> > > Samuel, as with the WM8400 are you OK with merging this via the
> > > regulator tree?
> > 
> > Samuel, are fine to Ack the MFD parts ?
> Sorry guys, but I havent had time to look at those patches yet.
> Liam, when would be the last moment for me to ACK/NACK them ?
> I expect to be able to do so during this weekend.

That would be fine. The intention is to do a pull request later next
week. Fwiw, most of the MFD stuff in this series is headers so should be
quick.

Cheers

Liam

