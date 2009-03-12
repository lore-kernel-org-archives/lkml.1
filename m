Return-Path: <linux-kernel-owner+w=401wt.eu-S1752356AbZCLIBZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356AbZCLIBZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 04:01:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZCLIBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 04:01:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:24115 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbZCLIBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 04:01:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,349,1233561600"; 
   d="scan'208";a="119455909"
Date: Thu, 12 Mar 2009 15:59:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: jack marrow <jackmarrow2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Memory usage per memory zone
Message-ID: <20090312075952.GA19331@localhost>
References: <e2dc2c680903110341g6c9644b8j87ce3b364807e37f@mail.gmail.com> <20090311114353.GA759@localhost> <e2dc2c680903110451m3cfa35d9s7a9fd942bcee39eb@mail.gmail.com> <20090311121123.GA7656@localhost> <e2dc2c680903110516v2c66d4a4h6a422cffceb12e2@mail.gmail.com> <20090311122611.GA8804@localhost> <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2dc2c680903120053w37968c1cy556812cef63f0896@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 12, 2009 at 09:53:27AM +0200, jack marrow wrote:
> > Can you paste /proc/vmstat, /proc/meminfo, /proc/zoneinfo and
> > /proc/slabinfo? Thank you.
> 
> Sure, but I don't know if it will help.
> 
> The oom info was from in the night, the rest is from now. I have no zoneinfo.
> 
> http://pastebin.com/m67409bc0

Thank you! So you are running a pretty old kernel?
