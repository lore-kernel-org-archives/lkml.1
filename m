Return-Path: <linux-kernel-owner+w=401wt.eu-S1759202AbZKFA1Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759202AbZKFA1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 19:27:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759070AbZKFA1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 19:27:14 -0500
Received: from vms173003pub.verizon.net ([206.46.173.3]:48753 "EHLO
	vms173003pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705AbZKFA1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 19:27:12 -0500
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 19:27:12 EST
Date: Thu, 05 Nov 2009 18:26:53 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>,
       Sujith Thomas <sujith.thomas@intel.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 0/6] [resend] thermal: improvements re. forced passive
 cooling
In-reply-to: <200910282349.06322.elendil@planet.nl>
Message-id: <alpine.LFD.2.00.0911051819180.19209@localhost.localdomain>
References: <1256542744-26569-1-git-send-email-elendil@planet.nl>
 <20091028153551.6c665ca1.akpm@linux-foundation.org>
 <200910282349.06322.elendil@planet.nl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It turned out there was no bug in the kernel...
...
> It would have been nice if it had made .32 from my first submission,

Yeah, the discussion settled down just as the merge window openend,
and this isn't high risk, so in retrospect I should have pushed
it into 2.6.32.

> but now it's fine for .33. It's not stable material.

I'll push the documentation update to 2.6.32.

I'll push the tweaks to 2.6.33.
I don't expec that this will need to be back-ported
as only advanced users who also have this BIOS bug will be messing
around setting their own custom passive trip point in the first place.

thanks,
Len Brown, Intel Open Source Technology Center

