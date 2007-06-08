Return-Path: <linux-kernel-owner+w=401wt.eu-S1031009AbXFHR3i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031009AbXFHR3i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 13:29:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968471AbXFHR3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 13:29:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50629 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762870AbXFHR33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 13:29:29 -0400
Date: Fri, 8 Jun 2007 13:28:52 -0400
From: Dave Jones <davej@redhat.com>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [patch 00/54] 2.6.21-stable review
Message-ID: <20070608172852.GP27332@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
	stable@kernel.org, Justin Forbes <jmforbes@linuxtx.org>,
	Zwane Mwaikambo <zwane@arm.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
	Chuck Wolber <chuckw@quantumlinux.com>,
	Chris Wedgwood <reviews@ml.cw.f00f.org>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Chuck Ebbert <cebbert@redhat.com>,
	Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
References: <20070608072127.352723000@sous-sol.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070608072127.352723000@sous-sol.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2007 at 12:21:27AM -0700, Chris Wright wrote:
 > This is the start of the stable review cycle for the 2.6.21.5 release.
 > There are 54 patches in this series, all will be posted as a response
 > to this one.  If anyone has any issues with these being applied, please
 > let us know.  If anyone is a maintainer of the proper subsystem, and
 > wants to add a Signed-off-by: line to the patch, please respond with it.
 > 
 > These patches are sent out with a number of different people on the
 > Cc: line.  If you wish to be a reviewer, please email stable@kernel.org
 > to add your name to the list.  If you want to be off the reviewer list,
 > also email us.

I'm wondering if it makes sense to do more regular releases of -stable
so that the patchqueue doesn't build up so much.   It's painful
to sit down and review lots of patches in one sitting.
Additionally, with lots of change, it's a real pain to figure out
"which one of the 50 patches that went into the last -stable
 makes my machine not boot"  (which I had to do recently).


Or maybe cc: the reviewer list when patches get added?

Or maybe both?

	Dave

-- 
http://www.codemonkey.org.uk
