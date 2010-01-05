Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377Ab0AEODO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0AEODO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 09:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754022Ab0AEODN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 09:03:13 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:46351 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752848Ab0AEODG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 09:03:06 -0500
Subject: [ANNOUNCE] The Linux Test Project has been Released for DECEMBER
	2009
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: ltp-list <ltp-list@lists.sf.net>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jiri Palecek <jpalecek@web.de>, Garrett Cooper <yanegomi@gmail.com>,
       Mike Frysinger <vapier@gentoo.org>, Cyril Hrubis <chrubis@suse.cz>,
       Radoslav Kolev <radoslav.kolev@rnd.bg>, Miao Xie <miaox@cn.fujitsu.com>,
       Henry Yei <hyei@mvista.com>, Paul Larson <paul.larson@canonical.com>,
       Tomori Mitani <mitani@ryobi.co.jp>, Caspar Zhang <czhang@redhat.com>,
       liubo <liubo2009@cn.fujitsu.com>
Content-Type: text/plain
Organization: IBM
Date: Tue, 05 Jan 2010 19:32:41 +0530
Message-Id: <1262700161.8226.25.camel@subratamodak.linux.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.2) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The Linux Test Project test suite has been released for the month of
DECEMBER 2009. Please see ltp/INSTALL file carefully, as, there has
been multiple changes for building/installing the test suite after the
recent changes in Makefile infrastructure.

The latest version of the test-suite contains 3000+ tests for the Linux
OS and can be found at:
http://ltp.sourceforge.net/,
Latest happenings in LTP can also be found at:
http://ltp.sourceforge.net/wiki/,
http://ltp.sourceforge.net/wikiArchives.php, and,
IRC: irc.freenode.org #ltp.

========================
DECEMBER 2009 Highlights:
======================== 
      * Cleanup and stabilization of new build system for various
        distros, archs and make versions,
------------------------------

==============================
DECEMBER 2009 LTP Contributors:
============================== 
     1. Jiri Palecek, 
     2. Garrett Cooper, 
     3. Mike Frysinger, 
     4. Cyril Hrubis, 
     5. Radoslav Kolev, 
     6. Miao Xie, 
     7. Henry Yei, 
     8. Paul Larson, 
     9. Tomori Mitani, 
    10. Caspar Zhang, 
    11. liubo,
------------------------------

==============================
Note(s) from the Maintainer:
==============================
Garrett & Mike still continued with their effort to stabilize the new
build system. Introspecting ourselves at the end of the year, i find LTP
as a community project is in strong footing. Following are the various
interesting statistics about LTP during this year 2009:

     1. Over 30 Institutions contributed throughout the year, 
     2. No. of Patches contributed to LTP increased by 232% compared to
        last year, 
     3. 93% more source files were affected due to patching, making
        those tests better, 
     4. There is more than 200% increase in the no. of new testcases
        contributed to LTP, 
     5. The source code size increased almost 12% over the last year,

This is indeed a great achievement for LTP. And with tremendous hope, i
would believe that LTP would scale more heights in this year and future,
and would remain the project for the community; contributed by the
community.

Our web site also contains other information such as:
- A Linux test tools matrix
- Technical papers
- How To's on Linux testing
- Code coverage analysis tool.

We would encourage the community to post results to
ltp-results@lists.sf.net,
patches, new tests, bugs or comments/questions to ltp-list@lists.sf.net,
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=103382 (for
New Bug(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=303382 (for
New Patch(s)),
http://sourceforge.net/tracker/?func=add&group_id=3382&atid=353382 (for
New Feature Request(s))

Happy testing, 
Regards-- 
Subrata,


