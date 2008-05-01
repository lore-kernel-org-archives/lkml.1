Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbYEACSO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbYEACSO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 22:18:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756263AbYEACRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 22:17:11 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:35723 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503AbYEACRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 22:17:09 -0400
Date: Thu, 1 May 2008 05:16:24 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andres Salomon <dilinger@queued.net>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: olpc_battery_trigger_uevent() is unused
Message-ID: <20080501021624.GT29330@cs181133002.pp.htv.fi>
References: <20080429222951.GB15987@cs181133002.pp.htv.fi> <20080429190137.5b519463@ephemeral>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080429190137.5b519463@ephemeral>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 29, 2008 at 07:01:37PM -0400, Andres Salomon wrote:
> On Wed, 30 Apr 2008 01:29:51 +0300
> Adrian Bunk <bunk@kernel.org> wrote:
> 
> > drivers/power/olpc_battery.c:olpc_battery_trigger_uevent() is unused.
> > 
> > Should it have been used?
> > 
> > cu
> > Adrian
> > 
> 
> It will get used once the olpc power management code makes it
> upstream.  The olpc_register_battery_callback stuff that Andrew removed
> was related to that.
> 
> Remove it now if you like, but I'm hoping to get it in for the 2.6.27
> merge window.

I'm not that trigger-happy.  ;-)

I was actually more interested in whether it should have been used
(AKA there would be a bug somewhere).

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

