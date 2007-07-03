Return-Path: <linux-kernel-owner+w=401wt.eu-S1760696AbXGCQpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760696AbXGCQpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 12:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757043AbXGCQpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 12:45:21 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:63729 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbXGCQpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 12:45:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=qhHA8DtUuc8mULO9wVEOJ/tgVCA/igIKWP7YBMONt+ErYSoaWGUnsZtXrTVJ2t0aMZMCxoO/e9I0JxgGBdqolrsYvzjkQgLCF4X247Q9+c6UNbHGks4rnM6GKHpPMShv3A0SN87H1q/b9NSiBVB9Kupjuy7jFEz0rjSHWl9RkEg=
Message-ID: <468A7D14.1050505@googlemail.com>
Date: Tue, 03 Jul 2007 18:45:08 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, reiserfs-devel@vger.kernel.org,
       "Vladimir V. Saveliev" <vs@namesys.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-ide@vger.kernel.org,
       David Chinner <dgc@sgi.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>,
       Mark Fortescue <mark@mtfhpc.demon.co.uk>,
       William Lee Irwin III <wli@holomorphy.com>
Subject: [1/2] 2.6.22-rc7: known regressions
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc7.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

List of Aces

Name                    Regressions fixed since 21-Jun-2007
Hugh Dickins                           2
Andi Kleen                             1
Andrew Morton                          1
Benjamin Herrenschmidt                 1
Björn Steinbrink                       1
Bjorn Helgaas                          1
Jean Delvare                           1
Olaf Hering                            1
Siddha, Suresh B                       1
Trent Piepho                           1
Ville Syrjälä                          1



FS

Subject    : 2.6.22-rc4-git5 reiserfs: null ptr deref.
References : http://lkml.org/lkml/2007/6/13/322
Submitter  : Randy Dunlap <randy.dunlap@oracle.com>
Handled-By : Vladimir V. Saveliev <vs@namesys.com>
Status     : problem is being debugged



IDE

Subject    : 2.6.22-rcX: hda: lost interrupt
References : http://lkml.org/lkml/2007/6/29/121
Submitter  : David Chinner <dgc@sgi.com>
Status     : unknown



Sparc64

Subject    : random invalid instruction occourances on sparc32 (sun4c)
References : http://lkml.org/lkml/2007/6/17/111
Submitter  : Mark Fortescue <mark@mtfhpc.demon.co.uk>
Status     : problem is being debugged

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
