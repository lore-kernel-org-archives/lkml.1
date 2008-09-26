Return-Path: <linux-kernel-owner+w=401wt.eu-S1754556AbYIZB7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556AbYIZB7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 21:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753114AbYIZB7i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 21:59:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:41243 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbYIZB7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:59:37 -0400
Message-ID: <48DC41D2.4090806@redhat.com>
Date: Thu, 25 Sep 2008 21:58:42 -0400
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
       agospoda@redhat.com, "Ronciak, John" <john.ronciak@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Graham, David" <david.graham@intel.com>, kkiel@suse.de,
       tglx@linutronix.de, chris.jones@canonical.com, arjan@linux.jf.intel.com
Subject: Re: e1000e NVM corruption issue status
References: <987CEB09A2567F4A963E1E226364E2D33A685B4B@orsmsx418.amr.corp.intel.com> <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
In-Reply-To: <Pine.WNT.4.63.0809251811330.1736@jbrandeb-desk.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Brandeburg, Jesse wrote:
> hardware affected:
> laptops and desktops with 82566 or 82567 based LAN parts, which are 
> machines with the ICH8 and ICH9 chipsets and a variety of processors.
> The machines I know of that have reported the issue include
> Lenovo X300
> HP 2510p
> Intel DP35JO
> Lenovo T61 (possibly)
> Lenovo X61 (possibly)

My Intel DG45ID board has an ICH10R chipset, and it also has an 82567LM, just as 
some of the affected systems.  Is there some reason why ICH10 is not 
susceptible, or have we simply not seen it?

-- Chris
