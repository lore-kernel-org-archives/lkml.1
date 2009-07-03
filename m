Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbZGCKlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbZGCKlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbZGCKlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:41:25 -0400
Received: from mga06.intel.com ([134.134.136.21]:47220 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752109AbZGCKlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:41:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="427365412"
Date: Fri, 3 Jul 2009 12:43:23 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Daniel Ribeiro <drwyrm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>
Subject: Re: [PATCHv3] PCAP regulator driver (for 2.6.32)
Message-ID: <20090703104321.GB4176@sortiz.org>
References: <1246072682.10360.424.camel@brutus> <20090627105150.GA4780@sirena.org.uk> <1246123618.3727.29.camel@brutus> <20090703093517.GA4176@sortiz.org> <1246615901.4438.1107.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246615901.4438.1107.camel@vega.slimlogic.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 11:11:41AM +0100, Liam Girdwood wrote:
> On Fri, 2009-07-03 at 11:35 +0200, Samuel Ortiz wrote:
> > Hi Daniel,
> > 
> > On Sat, Jun 27, 2009 at 02:26:58PM -0300, Daniel Ribeiro wrote:
> 
> > > 
> > > Ideally, Samuel would push the PCAP patches on -rc phase, so the
> > > sub-drivers can all be merged through the respective subsystem trees on
> > > the .32 merge window.
> > If that's ok with Liam, I'll take the regulator patch. Most of the pcap
> > patches are not rc material, so they will be merged along with the regulator
> > driver with the next merge window.
> > 
> > Liam, if you're fine with this patch, could you please SOB it ? Thanks.
> 
> Signed-off-by: Liam Girdwood <lrg@slimlogic.co.uk>
Thanks, patch applied to my for-next branch.

Cheers,
Samuel.

 
> Thanks!
> 
> Liam
> 
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
