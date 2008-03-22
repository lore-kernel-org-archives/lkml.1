Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbYCVFVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbYCVFVS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 01:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752253AbYCVFVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 01:21:10 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58589
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752092AbYCVFVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 01:21:09 -0400
Date: Fri, 21 Mar 2008 22:21:25 -0700 (PDT)
Message-Id: <20080321.222125.245725675.davem@davemloft.net>
To: rdreier@cisco.com
Cc: jesper.juhl@gmail.com, chrisw@sous-sol.org, linux-kernel@vger.kernel.org,
       stable@kernel.org, jmforbes@linuxtx.org, zwane@arm.linux.org.uk,
       tytso@mit.edu, rdunlap@xenotime.net, davej@redhat.com,
       chuckw@quantumlinux.com, reviews@ml.cw.f00f.org, mkrufky@linuxtv.org,
       cebbert@redhat.com, cavokz@gmail.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, gregkh@suse.de
Subject: Re: [patch 07/76] NIU: Bump driver version and release date.
From: David Miller <davem@davemloft.net>
In-Reply-To: <adalk4bv62r.fsf@cisco.com>
References: <9a8748490803211710u4c5d1d67x2a5a891347e0adf6@mail.gmail.com>
	<20080321.171401.49157146.davem@davemloft.net>
	<adalk4bv62r.fsf@cisco.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roland Dreier <rdreier@cisco.com>
Date: Fri, 21 Mar 2008 19:35:40 -0700

>  > It makes a difference for driver maintainers when users
>  > report bugs and we ask them for the version printed
>  > by the driver so that we know which fixes have been
>  > applied.
> 
> I'm not sure if this series of patches really accomplishes that...
> you're leaving out some patches such as "[NIU]: Fix 1G PHY link state
> handling." that are in the real 0.7.  So the 2.6.24.stable version 0.7
> has a different set of fixes than the 2.6.25 version 0.7.

That was an oversight and not intentional, thanks for
for catching that.
