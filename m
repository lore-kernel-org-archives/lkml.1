Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0CHMv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 07:51:28 -0500
Received: from cantor.suse.de ([195.135.220.2]:52006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750880Ab0CHMvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 07:51:25 -0500
Date: Mon, 8 Mar 2010 13:51:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Micki Balanga <micki@n-trig.com>
Cc: rafi@seas.upenn.edu, chatty@enac.fr, peterhuewe@gmx.de,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: N-trig Finger Pen Multitouch fix
In-Reply-To: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
Message-ID: <alpine.LNX.2.00.1003081348470.17799@pobox.suse.cz>
References: <48A28051AC6D7A48B64F28272458190301AF29@Exchange-IL.n-trig.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Mar 2010, Micki Balanga wrote:

> The purpose of this patch is to enable Linux users to experience the 
> complete N-trig DuoSense pen and true multi-touch solution capabilities 
> over a Linux platform. This driver has been carefully and thoroughly 
> tested by N-trig, over a period of several months.
> 
> N-trig is changing the way people interact with computers by providing a 
> dual-mode pen and true multi-touch input device, specifically designed 
> for today's advanced computing world. N-trig DuoSense® solution provides 
> a real Hands-on computing® experience, and sets the stage for OEMs and 
> ISVs to introduce innovative computer products and applications for an 
> intuitive, Hands-on® experience directly onscreen. DuoSense digitizers 
> are easily integrated into existing technologies, support all LCDs, keep 
> devices slim and light, and can be implemented in a broad range of 
> products, ranging from small notebooks to large LCDs. N-trig has offices 
> in Israel, the US, Taiwan and Japan.
> 
> Signed-off-by: Micki Balanga <micki@n-trig.com>

Thanks for the patch.

As you are very well aware, we already have n-trig driver written by Rafi 
Rubin. I understand that your patch is implementing new features that 
Rafi's patch is not able to handle, and also re-factoring the driver in a 
non-trivial way.

Therefore it would be nice, if you could separate out the individual 
changes/additions to be based on top of the driver that we already have, 
and accompany them with nice changelog describing what changes are being 
done and why 

Or even Rafi volunteered to do this, as I can see -- thanks for that! It 
would still be nice to get Acked-by from the N-Trig guys for the changes 
at least.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
