Return-Path: <linux-kernel-owner+w=401wt.eu-S1755166AbYILJ7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166AbYILJ7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 05:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752692AbYILJ6z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 05:58:55 -0400
Received: from atlas.informatik.uni-freiburg.de ([132.230.150.3]:52199 "EHLO
	atlas.informatik.uni-freiburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752185AbYILJ6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 05:58:54 -0400
Date: Fri, 12 Sep 2008 11:58:51 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<ukleinek@informatik.uni-freiburg.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Paul Bolle <pebolle@tiscali.nl>
Subject: MAINTAINERS cleanup
Message-ID: <20080912095851.GA3174@informatik.uni-freiburg.de>
Mail-Followup-To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <ukleinek@informatik.uni-freiburg.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Paul Bolle <pebolle@tiscali.nl>
References: <20080908221139.GA10991@cassiopeia.tralala> <1221003422.3604.14.camel@test.thuisdomein> <20080910193210.GA26173@informatik.uni-freiburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080910193210.GA26173@informatik.uni-freiburg.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Organization: Universitaet Freiburg, Institut f. Informatik
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

here comes a new version of my MAINTAINERS cleanup series.

I made the following changes since last time:

 - remove one P/M entry for CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
   that refers to kernel 2.2 and has a failing email address.

 - move the removing of Nils' realname to the commit where the same
   change is done for some other people.

The resulting shortlog and diffstat are below.

I updated my branch at

	git://www.modarm9.com/gitsrc/pub/people/ukleinek/linux-2.6.git maintainers

with the current patches and will send them as a reply to this mail.

On top of these fixing the alphabetical ordering and merging P and M
fields with my script is possible.  (The branch above has the change,
but I will not send the resulting patches because they are too big.)

Best regards
Uwe

Uwe Kleine-König (4):
      MAINTAINERS: Remove a stale entry refering to kernel 2.2
      MAINTAINERS: add a realname for adilger@sun.com
      MAINTAINERS: remove real names from M fields
      MAINTAINERS: put corresponding realnames and mail addresses together

 MAINTAINERS |   18 ++++++++----------
 1 files changed, 8 insertions(+), 10 deletions(-)

-- 
Uwe Kleine-König

dd if=/proc/self/exe bs=1 skip=1 count=3 2>/dev/null
