Return-Path: <linux-kernel-owner+w=401wt.eu-S935678AbXFFUvI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935678AbXFFUvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:51:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934876AbXFFUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:50:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:46849 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934738AbXFFUu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:50:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,390,1175497200"; 
   d="scan'208";a="236361889"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
Date: Wed, 6 Jun 2007 13:50:41 -0700
User-Agent: KMail/1.9.6
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
References: <200706061229.24486.jesse.barnes@intel.com> <200706061331.30516.jesse.barnes@intel.com> <Pine.LNX.4.64.0706061636550.21038@p34.internal.lan>
In-Reply-To: <Pine.LNX.4.64.0706061636550.21038@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706061350.42508.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 6, 2007 1:37 pm Justin Piszcz wrote:
> On Wed, 6 Jun 2007, Jesse Barnes wrote:
> > On Wednesday, June 6, 2007 1:28 pm Jesse Barnes wrote:
> >>> Against what kernel version does this patch apply?
> >>
> >> Um... git as of b4946ffb1860597b187d78d61ac6504177eb0ff8.  Sorry I
> >> should have updated before spinning the patch (will do now).
> >
> > Appears to apply cleanly to git head as of a minute ago too.
> >
> > Jesse
>
> Can you produce a patch against 2.6.22-rc4 or 2.6.21 so I and other
> people can easily try it? I do not have git installed on this
> machine, thanks.

Seems to apply cleanly to 2.6.22-rc4 too.  Haven't tested that though.

Jesse
