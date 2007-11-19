Return-Path: <linux-kernel-owner+w=401wt.eu-S1753484AbXKSVxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbXKSVxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 16:53:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751545AbXKSVxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 16:53:09 -0500
Received: from gir.skynet.ie ([193.1.99.77]:33696 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751485AbXKSVxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 16:53:08 -0500
Date: Mon, 19 Nov 2007 21:53:05 +0000 (GMT)
From: Dave Airlie <airlied@linux.ie>
X-X-Sender: airlied@skynet.skynet.ie
To: "Bastian, Waldo" <waldo.bastian@intel.com>
cc: Dave Airlie <airlied@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
       DRI <dri-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org
Subject: Re: Prospects of DRM TTM making it into 2.6.24?
In-Reply-To: <1B47D24854C7BC4FA8DA28BEBB59B0BA029CD00D@orsmsx419.amr.corp.intel.com>
Message-ID: <alpine.DEB.0.82.0711192151010.1284@skynet.skynet.ie>
References: <1B47D24854C7BC4FA8DA28BEBB59B0BA029CD00D@orsmsx419.amr.corp.in
 tel.com>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="29444707-1966057021-1195509185=:1284"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--29444707-1966057021-1195509185=:1284
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


> What are the prospects of the DRM TTM changes making it into 2.6.24? I 
> noticed that Andrew has them [1] in his mm tree... any chance of that 
> getting pushed into Linus' tree for 2.6.24?
> 

No the merge window for 2.6.24 closed a few weeks ago. TTM wasn't in -mm 
for the 2.6.23 cycle as we hadn't finished the API stabilisation work in 
time. So I don't expect we'll see it before 2.6.25.

I also have a few AGP changes I need to line up to support the chipset 
flushing work I've done to support TTM properly..

Dave.

On Mon, 19 Nov 2007, Bastian, Waldo wrote:

> Cheers,
> Waldo
> 
> [1] http://userweb.kernel.org/~akpm/mmotm/broken-out/git-drm.patch 
> 
> Intel Corporation - Platform Software Engineering, UMG - Hillsboro, Oregon
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2005.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
> 
> 
--29444707-1966057021-1195509185=:1284--
