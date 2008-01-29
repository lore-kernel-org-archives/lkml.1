Return-Path: <linux-kernel-owner+w=401wt.eu-S1758386AbYA2XKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386AbYA2XKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 18:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbYA2XKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 18:10:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:26449 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbYA2XK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 18:10:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,271,1199692800"; 
   d="scan'208";a="255748856"
Message-ID: <479FB225.7090604@intel.com>
Date: Tue, 29 Jan 2008 15:09:25 -0800
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071125)
MIME-Version: 1.0
To: andi@lisas.de
CC: e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, bunk@kernel.org
Subject: Re: [RFC/PATCH] e100 driver didn't support any MII-less PHYs...
References: <20071228235118.GA31059@rhlx01.hs-esslingen.de> <477732A5.5020501@intel.com> <20080101200908.GA14805@rhlx01.hs-esslingen.de> <20080129230315.GA13389@rhlx01.hs-esslingen.de>
In-Reply-To: <20080129230315.GA13389@rhlx01.hs-esslingen.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Mohr wrote:
> Hi,
> 
> On Tue, Jan 01, 2008 at 09:09:08PM +0100, Andreas Mohr wrote:
>> Thanks for your quick reply!
>>
>> OK, here's part 1, the MII-less support stuff.
>> (preliminary posting, for review only)
>>
>> Note that these diffs apply to 2.6.24-rc6-mm1 without much trouble,
>> thus might want to do -mm testing soon.
> 
> Any verdict on this one?
> 
> I happen to be asking now since silly me just ""upgraded"" a mere mortal's
> sorta-production machine to 2.6.24 proper without remembering
> that the previous -rc6 had contained a minor but effective change
> to make those wires do their thing. Or, to tell it as it was,
> "Mom wasn't impressed ;)".
> 
> Perhaps it's useful to file a bug/patch
> on http://sourceforge.net/projects/e1000/ ? Perhaps -mm testing?

I wanted to push this though our testing labs first which has not happened due to
time constraints - that should quickly at least confirm that the most common nics
work OK after the change with your patch. I'll try and see if we can get this
testing done soon.

Auke


