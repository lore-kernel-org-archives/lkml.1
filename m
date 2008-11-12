Return-Path: <linux-kernel-owner+w=401wt.eu-S1754271AbYKLRkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271AbYKLRkk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:40:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753900AbYKLRkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:40:14 -0500
Received: from mail.ukfsn.org ([77.75.108.10]:37256 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753836AbYKLRkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:40:13 -0500
Date: Wed, 12 Nov 2008 17:40:10 +0000
From: Nick Warne <nick@ukfsn.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make Dell keyboard repeat quirk apply to a wider range
 of hardware
Message-ID: <20081112174010.209149e1@palantir.linicks.net>
In-Reply-To: <20081112172712.GA16382@srcf.ucam.org>
References: <20081111074702.75e71055@sauron.linicks.net>
	<20081112131427.1bbc2a7c@palantir.linicks.net>
	<20081112165650.GA15594@srcf.ucam.org>
	<20081112172429.674c4ff3@palantir.linicks.net>
	<20081112172712.GA16382@srcf.ucam.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Nov 2008 17:27:12 +0000
Matthew Garrett <mjg59@srcf.ucam.org> wrote:

> On Wed, Nov 12, 2008 at 05:24:29PM +0000, Nick Warne wrote:
> 
> > But how you determine if these certain laptops produce a keypress
> > release I don't know with having all of them at hand...
> 
> The quirk is only applied to a small number of keys which wouldn't
> want autorepeat anyway, so it's pretty clearly harmless even if the
> hardware works sanely.
> 
> > So it needs BOTH 'Dell Inc.' and 'Dell Computer Corporation' to
> > cover these laptops (I guess), as per the info I got from people
> > running dmidecode:
> 
> That's what the patch adds. I don't have appropriate hardware to test.
> 

Yes.

I have copied to the Ubuntu bug report (they already pushed out your
first patch) so hopefully people there can test it as I don't have this
hardware either.

BTW, what was it that produced this issue in the first place?  All
previous kernel versions worked OK?

Thanks,

Nick

-- 
Free Software Foundation Associate Member 5508
