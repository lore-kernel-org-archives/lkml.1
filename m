Return-Path: <linux-kernel-owner+w=401wt.eu-S1753387AbYI1UuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387AbYI1UuA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 16:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbYI1Utv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 16:49:51 -0400
Received: from dmz4.indranet.co.nz ([203.97.93.68]:56498 "EHLO
	XServe-2.services.indranet.co.nz" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752153AbYI1Utv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 16:49:51 -0400
X-Greylist: delayed 428 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Sep 2008 16:49:50 EDT
Date: Mon, 29 Sep 2008 09:45:20 +1300 (NZDT)
From: Derek Smithies <derek@indranet.co.nz>
X-X-Sender: derek@kauri.acheron.indranet.co.nz
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
       ath5k-devel@venema.h4ckr.net, linux-kernel@vger.kernel.org
Subject: Re: [ath5k-devel] Release of Atheros 802.11abg HAL under the ISC
In-Reply-To: <20080926215701.GC5972@tesla>
Message-ID: <alpine.DEB.1.00.0809290934160.15291@kauri.acheron.indranet.co.nz>
References: <20080926215701.GC5972@tesla>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis,
On Fri, 26 Sep 2008, Luis R. Rodriguez wrote:

> As part of our commitment to help support all of our Atheros devices
> under Linux we'd like to announce the release of our Atheros HAL for
> our 802.11abg chipsets under the ISC license.
>
> You can find it here:
>
> http://www.kernel.org/pub/linux/kernel/people/mcgrof/legacy-hal.tar.bz2
>
> This can be used as a source of documentation to help ath5k move
> forward to support our 802.11abg chipsets as best as possible in
> the Linux kernel. We look forward to keep working strongly with the
> community on advancing support of all our Atheros chipsets under Linux.
>
>  Luis

A huge vote of thanks and congratulations are due to Atheros for 
taking the step of releasing the HAL. There will be many in the open 
source community celebrating this move.

Much Kudos is due to Atheros for taking this step.

The ath5k community is going to benefit hugely from being able to optimise 
the driver based on a more accurate knowledge of the workings of the HAL.

Patches like
https://lists.ath5k.org/pipermail/ath5k-devel/2008-September/001311.html
will improve the reliability, and are only possible because of the release
of the HAL.

Thanks are due to Luis also, for taking his part in getting the HAL 
released.

Perhaps we can all now work together on getting a stable driver for 
Atheros cards under Linux. - Ath5k or Ath9k (don't care which).

Derek.
-- 
Derek Smithies Ph.D.
IndraNet Technologies Ltd.
Email: derek@indranet.co.nz
ph +64 3 365 6485
Web: http://www.indranet-technologies.com/
