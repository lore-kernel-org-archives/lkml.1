Return-Path: <linux-kernel-owner+w=401wt.eu-S1754146AbYIZCE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754146AbYIZCE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbYIZCEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:04:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:50249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506AbYIZCEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:04:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,310,1220252400"; 
   d="scan'208";a="620449699"
Date: Thu, 25 Sep 2008 19:04:46 -0700 (Pacific Daylight Time)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: Chris Snook <csnook@redhat.com>
cc: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
       LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
In-Reply-To: <48DC41D2.4090806@redhat.com>
Message-ID: <Pine.WNT.4.63.0809251903450.1736@jbrandeb-desk.amr.corp.intel.com>
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com>
 <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
 <48DC41D2.4090806@redhat.com>
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jesse.brandeburg@intel.com@imap.glb.intel.com
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008, Chris Snook wrote:

> Brandeburg, Jesse wrote:
> > hardware affected:
> > laptops and desktops with 82566 or 82567 based LAN parts, which are machines
> > with the ICH8 and ICH9 chipsets and a variety of processors.
> > The machines I know of that have reported the issue include
> > Lenovo X300
> > HP 2510p
> > Intel DP35JO
> > Lenovo T61 (possibly)
> > Lenovo X61 (possibly)
> 
> My Intel DG45ID board has an ICH10R chipset, and it also has an 82567LM, just
> as some of the affected systems.  Is there some reason why ICH10 is not
> susceptible, or have we simply not seen it?

ICH10R with 82567 is also susceptible, as far as I know at this point.
