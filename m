Return-Path: <linux-kernel-owner+w=401wt.eu-S933744AbXFEXHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744AbXFEXHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 19:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765451AbXFEXHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 19:07:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:53041
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1765046AbXFEXHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 19:07:21 -0400
Date: Tue, 05 Jun 2007 16:07:35 -0700 (PDT)
Message-Id: <20070605.160735.71091132.davem@davemloft.net>
To: michal.k.k.piotrowski@gmail.com
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, uwe.bugla@gmx.de,
       kenchen@google.com, dwmw2@infradead.org, Artem.Bityutskiy@nokia.com,
       hskinnemoen@atmel.com, clameter@sgi.com, airlied@linux.ie,
       righiandr@users.sourceforge.net, netdev@vger.kernel.org,
       a.strobl@aws-it.at, kaber@trash.net
Subject: Re: [1/2] 2.6.22-rc4: known regressions with patches
From: David Miller <davem@davemloft.net>
In-Reply-To: <46657924.4010505@googlemail.com>
References: <46657924.4010505@googlemail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Date: Tue, 05 Jun 2007 16:54:28 +0200

> Networking
> 
> Subject    : OOPS iproute2/tc/u32_destroy in 2.6.22-rc3-git6
> References : http://lkml.org/lkml/2007/6/3/66
> Submitter  : Strobl Anton <a.strobl@aws-it.at>
> Handled-By : Patrick McHardy <kaber@trash.net>
> Patch      : http://lkml.org/lkml/2007/6/3/137
> Status     : patch available

This slipped through the cracks, I've applied Patrick's
patch and will push upstream.

Thanks!
