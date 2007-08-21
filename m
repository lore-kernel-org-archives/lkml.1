Return-Path: <linux-kernel-owner+w=401wt.eu-S1753388AbXHUUg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbXHUUg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 16:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751608AbXHUUgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 16:36:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56899 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbXHUUgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 16:36:20 -0400
Date: Wed, 22 Aug 2007 02:18:57 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Geoff Levand <geoffrey.levand@am.sony.com>
cc: Rene Herman <rene.herman@gmail.com>, Joe Perches <joe@perches.com>,
       cbe-oss-dev-owner@ozlabs.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       mokuno@sm.sony.co.jp
Subject: Re: [PATCH] PS3: Update MAINTAINERS
In-Reply-To: <46CB4862.9020601@am.sony.com>
Message-ID: <alpine.LFD.0.999.0708220213110.24712@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene>  <1070816112100.12182@suse.de>
  <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be> 
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr> 
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be> 
 <alpine.LFD.0.999.0708210523470.2774@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.62.0708210904220.11703@pademelon.sonytel.be> 
 <alpine.LFD.0.999.0708211500100.2774@enigma.security.iitk.ac.in> 
 <Pine.LNX.4.62.0708211148040.6982@pademelon.sonytel.be> 
 <alpine.LFD.0.999.0708211605320.2774@enigma.security.iitk.ac.in> 
 <46CB3679.3070403@am.sony.com> <1187726479.5963.118.camel@localhost>
 <46CB45D8.9020801@gmail.com> <46CB4862.9020601@am.sony.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, 21 Aug 2007, Geoff Levand wrote:

> Rene Herman wrote:
> > On 08/21/2007 10:01 PM, Joe Perches wrote:
> > 
> >> On Tue, 2007-08-21 at 12:01 -0700, Geoff Levand wrote:
> > 
> >>> Could you verify that cbe-oss-dev is a subscriber's
> >>> only list?  I didn't see anything that said it
> >>> specifically in the listinfo.
> >> 
> >> This is the "hold" message I got on posting to that list.
> >> 
> >> Your mail to 'cbe-oss-dev' with the subject
> >> 
> >>     Re: [PATCH] [392/2many] MAINTAINERS - PS3 PLATFORM SUPPORT
> >> 
> >> Is being held until the list moderator can review it for approval.
> >> 
> >> The reason it is being held:
> >> 
> >>     Post by non-member to a members-only list
> > 
> > That means it's not a subcriber-only list -- the message wasn't rejected, 
> > just subjected to moderation.

That's precisely a subscribers-only list. At least as per MAINTAINER's
definition of that term. It'd be surprising to know of a mailing list
mentioned in MAINTAINERS that _drops_ messages posted to it entirely!

> So maybe it would be more precise to have something like this:
> 
> -L:	cbe-oss-dev@ozlabs.org
> +L:	cbe-oss-dev@ozlabs.org	(moderated)

Exactly a similar message greets those who post to linux-arm-kernel@
and it (and other such lists) is referred to everywhere in that file
as (subscribers-only), for example. The patch is correct, IMO.

Thanks,

Satyam
