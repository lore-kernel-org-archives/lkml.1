Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab0CEOhB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 09:37:01 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40014
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752506Ab0CEOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 09:36:59 -0500
Date: Fri, 05 Mar 2010 06:37:18 -0800 (PST)
Message-Id: <20100305.063718.211238119.davem@davemloft.net>
To: alan@lxorguk.ukuu.org.uk
Cc: mingo@elte.hu, skeggsb@gmail.com, torvalds@linux-foundation.org,
       airlied@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
References: <1267748927.3496.6.camel@nisroch>
	<20100305064955.GA6453@elte.hu>
	<20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Fri, 5 Mar 2010 12:38:34 +0000

>> The conclusion is crystal clear, breaking an ABI via a "flag day" 
>> cleanup/feature/etc is:
> 
> Ingo go read the staging Kconfig. It's crystal clear, and lots of vendor
> junk that is in there being cleaned up it would be *insane* to keep their
> old APIs
> 
> See there's a bigger offence than breaking an ABI - its called not RTFM.

All of this RTFM and what directory the noveau driver is sitting in is
entirely irrelevant Alan.

If it effects such a large number of people, which this noveau thing
does, it's entirely relevant to everyone.  And the way it's breaking
and making kernel development difficult for so many people matters to
us.

It's about the tester base, and this breakage shrinks the tester base
considerably.

Or do you want the kernel tested by less people?
