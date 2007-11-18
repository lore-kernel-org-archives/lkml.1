Return-Path: <linux-kernel-owner+w=401wt.eu-S1754005AbXKRND0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005AbXKRND0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 08:03:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbXKRNDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 08:03:15 -0500
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:47974 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834AbXKRNDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 08:03:14 -0500
Message-ID: <474036EA.9040600@keyaccess.nl>
Date: Sun, 18 Nov 2007 13:58:18 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Mark Lord <liml@rtr.ca>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, protasnb@gmail.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       alsa-devel@alsa-project.org, linux-ide@vger.kernel.org,
       linux-pcmcia@lists.infradead.org, linux-input@atrey.karlin.mff.cuni.cz,
       bugme-daemon@bugzilla.kernel.org
Subject: Re: size of git repository (was Re: [BUG] New Kernel Bugs)
References: <20071113031553.3c7b5c16.akpm@linux-foundation.org> <20071113.033946.114918709.davem@davemloft.net> <20071113034916.2556edd7.akpm@linux-foundation.org> <20071113.035824.40509981.davem@davemloft.net> <20071113041259.79c9a8c5.akpm@linux-foundation.org> <20071113134029.GA30978@elte.hu> <4739AFE0.20705@rtr.ca> <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071118124404.GA4037@ucw.cz>
In-Reply-To: <20071118124404.GA4037@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: 0.0 (/)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-11-07 13:44, Pavel Machek wrote:

> On Tue 2007-11-13 12:50:08, Mark Lord wrote:

>> It's a 540MByte download over a slow link for everyone 
>> else.
> 
> Hmmm, clean-cg is 7.7G on my machine, and yes I tried
> git-prune-packed. What am I doing wrong?

clean-cg? But failure to run "git repack -a -d" every once in a while?

Rene.
