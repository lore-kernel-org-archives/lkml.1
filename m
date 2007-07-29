Return-Path: <linux-kernel-owner+w=401wt.eu-S1761714AbXG2J4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761714AbXG2J4O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 05:56:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761030AbXG2J4E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 05:56:04 -0400
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:39732 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760986AbXG2J4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 05:56:03 -0400
Date: Sun, 29 Jul 2007 11:57:40 +0200
From: Rodolfo Giometti <giometti@enneenne.com>
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Chris Friesen <cfriesen@nortel.com>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Message-ID: <20070729095740.GA9840@enneenne.com>
References: <1185284942.14697.319.camel@pmac.infradead.org> <20070724142050.GD4074@enneenne.com> <1185288769.14697.339.camel@pmac.infradead.org> <20070727184418.GV9840@enneenne.com> <46AA42CA.4060004@nortel.com> <20070727192848.GW9840@enneenne.com> <46AA4A1E.8040302@nortel.com> <20070727194516.GX9840@enneenne.com> <a781481a0707271347w53dd9755j87e7762cfe953777@mail.gmail.com> <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a781481a0707271641n20353a12u7467d093346f2f4c@mail.gmail.com>
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

On Sat, Jul 28, 2007 at 05:11:17AM +0530, Satyam Sharma wrote:
> 
> Ok, I've looked through (most of) the RFC and code now, and am only
> commenting on a design-level for now. Anyway, I didn't like the way
> you've significantly drifted from the RFC in several ways:

Please, read documentation file Documentation/pps/pps.txt where I
exaplain why I did such RFC changes in my implementation.

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail:    giometti@enneenne.com
Linux Device Driver                             giometti@gnudd.com
Embedded Systems                     		giometti@linux.it
UNIX programming                     phone:     +39 349 2432127
