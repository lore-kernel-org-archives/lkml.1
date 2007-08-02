Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbXHBMG0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbXHBMG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 08:06:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754056AbXHBMGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 08:06:15 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38294 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813AbXHBMGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 08:06:14 -0400
Date: Thu, 2 Aug 2007 14:06:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: trenn@suse.de, linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       pavel@ucw.cz, mjg59@srcf.ucam.org, lenb@kernel.org,
       Adrian =?iso-8859-1?Q?Schr=F6ter?= <adrian@suse.de>,
       "Zhang, Rui" <rui.zhang@intel.com>, Jean Delvare <khali@linux-fr.org>,
       Alexey Starikovskiy <aystarik@gmail.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: 2.6.22 regression: thermal trip points
Message-ID: <20070802120613.GB440@one.firstfloor.org>
References: <46B1988C.3090302@t-online.de> <1186047747.18821.450.camel@queen.suse.de> <46B1C0BA.1020004@t-online.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46B1C0BA.1020004@t-online.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi Kleen wrote:
> 
>   > I don't think it's that unreasonable to require source code
> modifications
>   >  for anything that can kill hardware. At least that raises the barrier
>   >  a bit and hopefully ensures people think twice about it and then really
>   > only blame themselves if anything goes wrong.
> 
> Andi, would the above be mechanism sufficiently safe for your taste?

No.

-Andi
