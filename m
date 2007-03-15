Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXCORbi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXCORbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 13:31:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbXCORbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 13:31:38 -0400
Received: from csclub1.cs.uwaterloo.ca ([129.97.7.226]:53260 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750782AbXCORbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 13:31:38 -0400
Date: Thu, 15 Mar 2007 13:31:37 -0400
To: takada <takada@mbf.nifty.com>
Cc: rdreier@cisco.com, pcnet32@verizon.net, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: MediaGX/GeodeGX1 requires X86_OOSTORE.
Message-ID: <20070315173137.GJ22466@csclub.uwaterloo.ca>
References: <20070220000231.GM7585@csclub.uwaterloo.ca> <20070220.203413.260790539.takada@mbf.nifty.com> <20070220144823.GN7585@csclub.uwaterloo.ca> <20070315.143939.193680310.takada@mbf.nifty.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070315.143939.193680310.takada@mbf.nifty.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 02:39:39PM +0900, takada wrote:
> Hiroshi Miura posted `Geode out-of-order store enables' patch in Jun, 2003.
> There is http://lkml.org/lkml/2003/6/5/57 .
> OOSTORE was enabled at this point in time. It seems to have disappeared somewhere.

I believe the patch was rejected as 'not required' since the data sheet
is not very clear on that "feature".

> BTW, I use MediaGX with kernel 2.6.20(and 2.6.20.3) and suspend2. When I resume 
> the PC and use the PC Card modem, PC is hungup. However, PC isn't hung up when
> I apply a WBINVD patch.
> I can't understand it whether there is problem in resume of suspend2 or MediaGX
> or both. Many drivers lack support for resume on my PC.

Which patch are you refering to?

--
Len Sorensen
