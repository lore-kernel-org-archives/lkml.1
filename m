Return-Path: <linux-kernel-owner+w=401wt.eu-S935399AbZJOTsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935399AbZJOTsN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 15:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935391AbZJOTsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 15:48:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:35716 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935389AbZJOTsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 15:48:12 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AD77C4F.5010307@s5r6.in-berlin.de>
Date: Thu, 15 Oct 2009 21:47:27 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090926 SeaMonkey/1.1.17
MIME-Version: 1.0
To: david@lang.hm
CC: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: removing existing working drivers via staging
References: <alpine.DEB.2.00.0910142213590.22169@asgard.lang.hm> <200910151942.40259.bzolnier@gmail.com> <20091015174932.GA3595@suse.de> <200910152020.13080.bzolnier@gmail.com> <20091015184656.GA29858@suse.de> <alpine.DEB.2.00.0910151200100.22169@asgard.lang.hm> <20091015191641.GB19467@elte.hu> <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
In-Reply-To: <alpine.DEB.2.00.0910151230560.22169@asgard.lang.hm>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

david@lang.hm wrote:
> it's these users who will discover the missing driver and care about it,
> not the distros.

I think we are talking about stuff of which users will typically
discover that it plainly doesn't work long before it vanishes from any
kernel distribution, or of which there is a superior alternative already
available.
-- 
Stefan Richter
-=====-==--= =-=- -====
http://arcgraph.de/sr/
