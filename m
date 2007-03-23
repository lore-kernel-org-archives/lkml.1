Return-Path: <linux-kernel-owner+w=401wt.eu-S934031AbXCWINy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934031AbXCWINy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 04:13:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934257AbXCWINy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 04:13:54 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:12455 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934031AbXCWINw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 04:13:52 -0400
X-IronPort-AV: i="4.14,318,1170651600"; 
   d="scan'208"; a="25256181:sNHT6348536068"
Subject: Re: [PATCH -mm try#2] Blackfin: architecture update patch
From: "Wu, Bryan" <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: bryan.wu@analog.com, Arnd Bergmann <arnd@arndb.de>,
       Paul Mundt <lethal@linux-sh.org>,
       bert hubert <bert.hubert@netherlabs.nl>, linux-kernel@vger.kernel.org
In-Reply-To: <20070322235923.be143ea9.akpm@linux-foundation.org>
References: <1174471618.5648.50.camel@roc-desktop>
	 <20070321125631.GA13192@linux-sh.org>
	 <1174629871.18866.22.camel@roc-desktop>
	 <20070322235923.be143ea9.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Fri, 23 Mar 2007 16:14:00 +0800
Message-Id: <1174637640.18866.37.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-03-22 at 23:59 -0800, Andrew Morton wrote:
> On Fri, 23 Mar 2007 14:04:30 +0800 "Wu, Bryan" <bryan.wu@analog.com> wrote:
> 
> > This is the latest blackfin update patch.
> 
> I think I'm going to give up on the present set of blackfin patches.  I don't
> know whether what I have is up-to-date and various versions of various random
> patches keep on flying past.
> 

Sorry for this mess up. You know, this is a big patch. After Arnd and
Paul's review, it took lots of time to fix their request. But I think
this update patch is the patch to satisfy Arnd and Paul's review and
they almost think this one is fine to add to -mm.

> So I think it's best if I drop everything and, when people have finished reviewing
> everything, you resend it all.

If this one is merged into -mm, I will follow the rule to send small and
fixed patches. But you know incremental patch should have a base. I hope
you can add this to -mm. And if Arnd, Paul or other kernel maintainers
find some issues, we fix them and send small patches one by one.

Thanks Andrew.
-Bryan
