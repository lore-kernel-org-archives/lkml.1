Return-Path: <linux-kernel-owner+w=401wt.eu-S1762980AbZJOTlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762980AbZJOTlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbZJOTll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:41:41 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35693 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbZJOTlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:41:40 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AD77AC3.7040905@s5r6.in-berlin.de>
Date: Thu, 15 Oct 2009 21:40:51 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: david@lang.hm
CC: Greg KH <gregkh@suse.de>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: removing existing working drivers via staging
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> a driver in staging will be able to build, but a driver that was removed
> after 6-9 months that a user discovered the removal of a year later when
> they upgraded to a new distro release (say a normal ubuntu release after
> staying on the old one for the 18 month support period) is likely to
> need significant work to catch up with kernel changes in the meanwhile.

I don't think this new mechanism is meant to be, or can ever be, a way
to remove things that work and that users need.

Hence the timeline of 3 releases per <20091015164726.GA10125@suse.de>
affects developers/ janitors much more than end users.
-- 
Stefan Richter
-=====-==--= =-=- -====
http://arcgraph.de/sr/
