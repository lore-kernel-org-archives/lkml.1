Return-Path: <linux-kernel-owner+w=401wt.eu-S1752365AbXB1QxM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752365AbXB1QxM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 11:53:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752368AbXB1QxM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 11:53:12 -0500
Received: from [72.242.190.170] ([72.242.190.170]:6011 "EHLO iradimed.com"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752363AbXB1QxL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 11:53:11 -0500
X-Greylist: delayed 848 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Feb 2007 11:53:11 EST
Message-ID: <45E5B00E.8090003@cfl.rr.com>
Date: Wed, 28 Feb 2007 11:38:38 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
MIME-Version: 1.0
To: "Michael K. Edwards" <medwards.linux@gmail.com>
CC: Theodore Tso <tytso@mit.edu>, Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Arjan.van.de.Ven@vax.1wt.eu
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Arjan van de Ven
			^-extraneous tokens in address
Illegal-Object: Syntax error in CC: address found on vger.kernel.org:
	CC:	Arjan van de Ven
			^-extraneous tokens in address
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
References: <f2b55d220702211446l78af6f14hc3e0dd0084016770@mail.gmail.com>  <45DCD9E5.2010106@redhat.com> <20070222074044.GA4158@elte.hu>  <20070222113148.GA3781@2ka.mipt.ru>  <Pine.LNX.4.64.0702251428490.12485@woody.linux-foundation.org>  <20070226172812.GC22454@2ka <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
In-Reply-To: <f2b55d220702271903o6bc418efu7d72a564a7ade365@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Feb 2007 16:39:02.0214 (UTC) FILETIME=[F3FD7E60:01C75B56]
X-TM-AS-Product-Ver: SMEX-7.2.0.1122-3.6.1039-15026.000
X-TM-AS-Result: No--2.243100-5.000000-31
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Michael K. Edwards wrote:
> State machines are much harder to write without going through a real
> on-paper design phase first.  But multi-threaded code is much harder
> for a team of average working coders to write correctly, judging from
> the numerous train wrecks that I've been called in to salvage over the
> last ten years or so.

I have to agree; state machines are harder to design and read, but 
multithreaded programs are harder to write and debug _correctly_.

Another way of putting it is that the threadlet approach is easier to 
do, but harder to do _right_.

