Return-Path: <linux-kernel-owner+w=401wt.eu-S1759973AbXJDQbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759973AbXJDQbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 12:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756851AbXJDQbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 12:31:25 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:28082 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585AbXJDQbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 12:31:24 -0400
X-IronPort-AV: i="4.21,230,1188792000"; 
   d="scan'208"; a="53250678:sNHT27984516"
Subject: Re: Blackfin Ethernet MAC driver compile error
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Kalle Pokki <kalle.pokki@iki.fi>
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <a425f86c0710040726q27aeb354vbbcb68bd2fed2b76@mail.gmail.com>
References: <a425f86c0710020430o3507eeb2veb104dc936f230dd@mail.gmail.com>
	 <1191489141.6139.1.camel@roc-laptop>
	 <a425f86c0710040726q27aeb354vbbcb68bd2fed2b76@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Ltd.
Date: Fri, 05 Oct 2007 00:31:17 +0800
Message-Id: <1191515477.6361.3.camel@roc-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 04 Oct 2007 16:31:22.0099 (UTC) FILETIME=[FFCB0430:01C806A3]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-04 at 22:26 +0800, Kalle Pokki wrote:
> On 10/4/07, Bryan Wu <bryan.wu@analog.com> wrote: 
> > Sorry for missing the pinmux patches. 
> > After Linus's git-pull, it should be fixed in the latest Linus
> mainline 
> > git tree.
> 
> Thanks, it is working now. I was also glad to see the binfmt_flat 
> patch going in.

Yeah, thanks Linus to accept the patches 
> 
> Do you plan to get the PHY abstraction layer patches for the Blackfin 
> EMAC included in the upcoming merge window?

Currently, it is in Jeff's netdev-2.6.git tree. IMO, Jeff will send it
to Linus when merge window open.

Regards
-Bryan Wu
> 
