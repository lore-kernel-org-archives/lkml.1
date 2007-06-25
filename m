Return-Path: <linux-kernel-owner+w=401wt.eu-S1753925AbXFYJsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbXFYJsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 05:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751350AbXFYJs3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 05:48:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:52725 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbXFYJs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 05:48:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=VVjx5Kagfr/m7IwdhNR3wq6SocGwkQfw7Iyh9Jl67VviET+GvesHo/QP2Zte65mr6twzy5848kO1Y11KzHz/ooPJqaXMvn00vGscPI1jNPo1Jey8r7kTSD63Jq30DJipuhwPM6Fo1D5Vutcz53ryjIywAHx9Vxs4NLUKv9UzpYI=
Message-ID: <467F8F5A.3000205@googlemail.com>
Date: Mon, 25 Jun 2007 11:48:10 +0200
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Darrick J. Wong" <djwong@us.ibm.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Stephane Eranian <eranian@hpl.hp.com>,
       =?ISO-8859-2?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Trent Piepho <xyzzy@speakeasy.org>, Ingo Molnar <mingo@elte.hu>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Andi Kleen <ak@suse.de>
Subject: [1/2] 2.6.22-rc6: known regressions with patches
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc6
with patches available.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions

*STATISTICS* (a.k.a. list of aces)

Name                    Regressions fixed since 21-Jun-2007
Andi Kleen                             1
Hugh Dickins                           1
Jean Delvare                           1



Unclassified

Subject    : fix nmi_watchdog=2 bootup hang
References : http://lkml.org/lkml/2007/6/25/51
Submitter  : Ingo Molnar <mingo@elte.hu>
Caused-By  : Jeremy Fitzhardinge <jeremy@xensource.com>
             Andi Kleen <ak@suse.de>
             commit f8822f42019eceed19cc6c0f985a489e17796ed8
Status     : patch available

Subject    : Kconfig troubles when using menuconfig
References : http://lkml.org/lkml/2007/6/22/159
Submitter  : Mauro Carvalho Chehab <mchehab@infradead.org>
Handled-By : Trent Piepho <xyzzy@speakeasy.org>
Patch      : http://lkml.org/lkml/2007/6/23/244
Status     : patch available

Subject    : Device hang when offlining a CPU due to IRQ misrouting
References : http://lkml.org/lkml/2007/5/31/419
Submitter  : Darrick J. Wong <djwong@us.ibm.com>
Handled-By : Siddha, Suresh B <suresh.b.siddha@intel.com>
Patch      : http://lkml.org/lkml/2007/6/19/422
Status     : patch available

Subject    : OProfile issues
References : http://lkml.org/lkml/2007/6/12/207
Submitter  : Stephane Eranian <eranian@hpl.hp.com>
Handled-By : Björn Steinbrink <B.Steinbrink@gmx.de>
Patch      : http://lkml.org/lkml/2007/6/12/392
Status     : patch was suggested



Regards,
Michal

--
LOG
http://www.stardust.webpages.pl/log/
