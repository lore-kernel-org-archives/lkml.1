Return-Path: <linux-kernel-owner+w=401wt.eu-S936110AbYBVAoe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936110AbYBVAoe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 19:44:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761261AbYBVAoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 19:44:25 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:36170 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759021AbYBVAoY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 19:44:24 -0500
Message-ID: <47BE1AD8.4060600@garzik.org>
Date: Thu, 21 Feb 2008 19:44:08 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, Roland Dreier <rdreier@cisco.com>,
       Glenn Streiff <gstreiff@NetEffect.com>,
       Faisal Latif <flatif@NetEffect.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: Merging of completely unreviewed drivers
References: <5E701717F2B2ED4EA60F87C8AA57B7CC0794FFF1@venom2>	<5E701717F2B2ED4EA60F87C8AA57B7CC0794FFFF@venom2>	<20080221154951.GA28328@cs181133002.pp.htv.fi>	<adahcg2awag.fsf@cisco.com>	<20080221210124.GD28328@cs181133002.pp.htv.fi>	<alpine.LFD.1.00.0802211310370.19896@woody.linux-foundation.org>	<m3tzk1q3rt.fsf@maximus.localdomain> <47BE0C12.604@garzik.org> <m3k5kxq2ih.fsf@maximus.localdomain>
In-Reply-To: <m3k5kxq2ih.fsf@maximus.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzysztof Halasa wrote:
> Jeff Garzik <jeff@garzik.org> writes:
> 
>> If a driver is full of lines of length >80, that's a problem.
> 
> I'm not sure.
> We all have more than 80-chars wide displays for years, don't we? The

Every time this discussion comes up, people point out that it remains 
highly common to open multiple 80-column terminal windows, making the 
80-column limit still highly relevant in modern times.


> The
> problem is [...] code which is too
> complex and which may sometimes have too many levels of indentation.

Quite true.

	Jeff


