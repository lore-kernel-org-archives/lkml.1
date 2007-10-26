Return-Path: <linux-kernel-owner+w=401wt.eu-S1763040AbXJZVqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763040AbXJZVqK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 17:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXJZVp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 17:45:57 -0400
Received: from orion2.pixelized.ch ([195.190.190.13]:41555 "EHLO
	mail.pixelized.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931AbXJZVp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 17:45:57 -0400
Message-ID: <4722600A.4090903@cateee.net>
Date: Fri, 26 Oct 2007 23:45:46 +0200
From: Giacomo Catenazzi <cate@cateee.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Bart Van Assche <bart.vanassche@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: Is gcc thread-unsafe?
References: <e2e108260710260729x4603211cgb68d7434ce1e54e9@mail.gmail.com> <e2e108260710260740k27210c4fu2f75d5fb31ccdccc@mail.gmail.com> <alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0710260756260.30120@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:

> The gcc lists seem to often get to the point where people quote the 
> standard, and that's that. In that environment, the paper standard (that 
> hass *nothing* to do with reality) trumps any other argument. "What we do 
> is _allowed_ by the standard" seems to be a good argument, even if it 
> breaks real code and there is no sane way to avoid doing it.

So we have the great opportunity to change the standard, then
gcc will change ;-)

C is in pre-review phase, and it is taking proposal and correction for the C1x
(so in few kernel release ;-) )

ciao
	cate
