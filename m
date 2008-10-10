Return-Path: <linux-kernel-owner+w=401wt.eu-S1760703AbYJJOcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703AbYJJOcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 10:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756216AbYJJOby
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 10:31:54 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39762 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760207AbYJJObx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 10:31:53 -0400
Date: Fri, 10 Oct 2008 16:31:49 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Liam Girdwood <lrg@kernel.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/13] WM8350 support
Message-ID: <20081010143148.GB4823@localdomain>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <20081006123254.GA9664@rakim.wolfsonmicro.main> <1223648664.6814.323.camel@dell-desktop.example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223648664.6814.323.camel@dell-desktop.example.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 03:24:24PM +0100, Liam Girdwood wrote:
> On Mon, 2008-10-06 at 13:32 +0100, Mark Brown wrote:
> > These patches against the regulator tree add initial support for the
> > WM8350, a multi-function device with several subsystems targetted at
> > embedded systems.  This series adds a core driver providing device acess
> > under drivers/mfd and support for the PMIC functionality of the device
> > via the regulator API.  Due to their use in the core some definitions
> > for other parts of the device are also included - drivers for these will
> > follow.
> > 
> > All the WM8350 drivers submitted here were originally written by Liam
> > Girdwood with some updates from me for submission to mainline.
> > 
> > Samuel, as with the WM8400 are you OK with merging this via the
> > regulator tree?
> 
> Samuel, are fine to Ack the MFD parts ?
Sorry guys, but I havent had time to look at those patches yet.
Liam, when would be the last moment for me to ACK/NACK them ?
I expect to be able to do so during this weekend.

Cheers,
Samuel.

 
> Liam
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
