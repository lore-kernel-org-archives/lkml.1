Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753506AbYLRUye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYLRUye (ORCPT <rfc822;akpm@linux-foundation.org>);
	Thu, 18 Dec 2008 15:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752455AbYLRUyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 15:54:08 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:34605 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752401AbYLRUyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 15:54:07 -0500
Subject: Re: [PATCH V2 7/7] regulator: PCF50633 pmic driver
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Balaji Rao <balajirrao@openmoko.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Andy Green <andy@openmoko.com>
In-Reply-To: <20081218204705.GD2284@cff.thadambail>
References: <20081218055618.31696.65002.stgit@cff.thadambail>
	 <20081218055817.31696.67376.stgit@cff.thadambail>
	 <20081218100835.GA27075@rakim.wolfsonmicro.main>
	 <20081218151431.GB2284@cff.thadambail>
	 <1229632254.24727.1394.camel@vega.slimlogic.co.uk>
	 <20081218204705.GD2284@cff.thadambail>
Content-Type: text/plain
Date: Thu, 18 Dec 2008 20:54:04 +0000
Message-Id: <1229633644.24727.1452.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-19 at 02:17 +0530, Balaji Rao wrote:
> On Thu, Dec 18, 2008 at 08:30:54PM +0000, Liam Girdwood wrote:
> > On Thu, 2008-12-18 at 20:44 +0530, Balaji Rao wrote:
> > > On Thu, Dec 18, 2008 at 10:08:35AM +0000, Mark Brown wrote:
> > > > On Thu, Dec 18, 2008 at 11:28:17AM +0530, Balaji Rao wrote:
> > > > > Changes from V1:
> > > > > 	- Removed support for suspend_enable & suspend_disable functions.
> > > > > 
> > > > > Signed-off-by: Balaji Rao <balajirrao@openmoko.org>
> > > > > Cc: Andy Green <andy@openmoko.com>
> > > > > Cc: Liam Girdwood <lrg@simlogic.co.uk>
> > 
> > Applied.
> > 
> > Thanks
> > 
> 
> Liam, the pcf50633-regulator.c has depends on
> include/linux/mfd/pcf50633/core.patch which is not here, but in
> [PATCH 1/7] of the series. So, pcf50633-regulator.c it wouldn't
> build.
> 
> I was expecting it to make it to -next via linux-mfd - I've asked
> Samuel Ortiz about this in [0/7].
> 
> So, I was hoping you to ack this so that Samuel can take it into
> linux-mfd.
> 
> I apologize for the confusion.

Ok. Np.

Thanks

Liam 

