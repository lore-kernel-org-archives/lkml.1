Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbXGaTn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbXGaTn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 15:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754728AbXGaTnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 15:43:18 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:55436 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664AbXGaTnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 15:43:17 -0400
Date: Tue, 31 Jul 2007 21:44:57 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam@infradead.org>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070731194457.GB9840@enneenne.com>
References: <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <20070729091709.GY9840@enneenne.com> <alpine.LFD.0.999.0707300943550.10861@enigma.security.iitk.ac.in> <20070730083259.GD9840@enneenne.com> <alpine.LFD.0.999.0707301425540.13448@enigma.security.iitk.ac.in> <20070730145542.GG9840@enneenne.com> <alpine.LFD.0.999.0707310153110.17287@enigma.security.iitk.ac.in> <20070731082057.GM9840@enneenne.com> <alpine.LFD.0.999.0707312351020.28746@enigma.security.iitk.ac.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LFD.0.999.0707312351020.28746@enigma.security.iitk.ac.in>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.16 (2007-06-11)
X-SA-Exim-Connect-IP: 192.168.32.1
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: LinuxPPS & spinlocks
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 12:19:48AM +0530, Satyam Sharma wrote:

> That's just absolute bullshit.

...

> I'm sorry to say this, Rodolfo, but _all_ your arguments above are
> *totally* nonsensical and factually incorrect -- and I have had enough of
> trying to talk sense to you, it's been ~15 mails in this thread already,
> and I've been WASTING my time trying to teach / explain to you, but it's
> just *shocking* that you prefer to stick to a wholly incorrect (which I
> suspect you've already understood by now anyway) position rather than
> just accepting that the present patch is wrong and go about correcting
> it instead.
> [snip]

Sorry for wasting your time. :'( Maybe you can provide your solution
for PPS support and get it included into kernel tree so we can use it
and live happy!  :)

Several people (Andrew, David, et all) wrote to me a lot of letters
without loosing their patience. I'm a poor programmer, not a «guru»
like you, and I need more time to understand things. I'm trying to do
my best. :)

However I'm very proud to be a "poor programmer" (slow in
understanding things) but a gentleman rather than a "kernel-guru" like
you but totally ill-mannered.

Thanks anyway for your (precious) time,

Rodolfo

P.S. A gentle programmer just wrote to me a letter where, proposing
code/patches, showed to me possible good solutions, so I think I'm
going to modify again the locking code soon.

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
