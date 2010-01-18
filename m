Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045Ab0ARRTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045Ab0ARRTS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:19:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754813Ab0ARRTM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:19:12 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:54674 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab0ARRTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:19:10 -0500
Date: Mon, 18 Jan 2010 18:19:03 +0100
To: reinette chatre <reinette.chatre@intel.com>
Cc: "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ipw3945-devel] hang on 2.6.33-rc4
Message-ID: <20100118171903.GT3150@gamma.logic.tuwien.ac.at>
References: <20100115152215.GC2541@gamma.logic.tuwien.ac.at> <1263576588.2751.455.camel@rc-desk> <20100116183056.GA18769@gamma.logic.tuwien.ac.at> <1263834413.2751.644.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263834413.2751.644.camel@rc-desk>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: Norbert Preining <preining@logic.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Reinette,

On Mo, 18 Jan 2010, reinette chatre wrote:
> > > Does that mean no netconsole either? Does anything show up in the logs?
> > > Is it easy to reproduce? If so, perhaps you can have increased debug at
> > > that time and hopefully something will be captured in the logs when the
> > > problem occurs.

I tried it today, but had "real work" (university job) to do. It worked
and I found out that it happend (up to now) *NOT* when I was only doing
a ping on a server, but when I ssh-ed into my server it hang.

More testing tomorrow (here it is already 2am). 

BTW, logs were empty, unfortunately, complete hard hang.

> > Jan 17 03:28:58 mithrandir kernel: [34535.332419] iwlagn 0000:06:00.0: BUG_ON idx doesn't match seq control idx=170, seq_idx=3466, seq=55456
> > 
> > Actually many many many of these lines.
> > 
> 
> What you are seeing here is currently being looked into at
> http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2098 - could you
> please add your information there?

I did that, although I was not sure what information to provide.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan            TU Wien, Austria           Debian TeX Task Force
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
THURNBY (n.)
A rucked-up edge of carpet or linoleum which everyone says someone
will trip over and break a leg unless it gets fixed. After a year or
two someone trips over it and breaks a leg.
			--- Douglas Adams, The Meaning of Liff
