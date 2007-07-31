Return-Path: <linux-kernel-owner+w=401wt.eu-S1763235AbXGaVDa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763235AbXGaVDa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:03:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758937AbXGaVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:03:21 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56709 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754607AbXGaVDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:03:20 -0400
Date: Wed, 1 Aug 2007 02:45:39 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Rodolfo Giometti <giometti@enneenne.com>
cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: LinuxPPS & spinlocks
In-Reply-To: <20070731194457.GB9840@enneenne.com>
Message-ID: <alpine.LFD.0.999.0708010217000.28746@enigma.security.iitk.ac.in>
References: <20070727194516.GX9840@enneenne.com>
 <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com>
 <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in>
 <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in>
 <20070730145542.GG9840@enneenne.com> <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in>
 <20070731082057.GM9840@enneenne.com> <alpine.LFD.0.999.0707312351020.28746@enigma.security.iitk.ac.in>
 <20070731194457.GB9840@enneenne.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Tue, 31 Jul 2007, Rodolfo Giometti wrote:

> Sorry for wasting your time. :'( Maybe you can provide your solution
> for PPS support and get it included into kernel tree so we can use it
> and live happy!  :)

Please stop embarrassing me (and yourself).

Sorry, I did lose my patience (others you mention did not) but then
that's precisely because of my own _less_ experience, if anything.

No, it's not like I "want to provide my solution for PPS support and
get it included into kernel tree" like you wrote above -- I simply
identified 4 problem areas in your implementation and wanted them to
be addressed. [If you can do so yourself, good enough, otherwise I'm
happy to send patch based on your earlier one too -- the modifications
I have in mind are few and simple.] I have no personal stake in this
PPS stuff anyway, this is just a normal peer review of submissions
that should always happen.


Thanks,

Satyam
