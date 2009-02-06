Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZBFXLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZBFXLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 18:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZBFXLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 18:11:13 -0500
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:41605 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752239AbZBFXLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 18:11:12 -0500
Message-ID: <498CC380.1070705@lwfinger.net>
Date: Fri, 06 Feb 2009 17:10:56 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Hugh Dickins <hugh@veritas.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Mikael Pettersson <mikpe@it.uu.se>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>
Subject: Re: [Bug #12609] v2.6.29-rc2 libata sff 32bit PIO regression
References: <kkuKoQJIW-D.A.61C.auYiJB@chimera> <pWZw1SZjMCH.A.o-D.uuYiJB@chimera> <Pine.LNX.4.64.0902051723520.1445@blonde.anvils> <200902052354.16361.rjw@sisk.pl>
In-Reply-To: <200902052354.16361.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Thursday 05 February 2009, Hugh Dickins wrote:
>> On Wed, 4 Feb 2009, Rafael J. Wysocki wrote:
>>> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12609
>>> Subject		: v2.6.29-rc2 libata sff 32bit PIO regression
>>> Submitter	: Larry Finger <Larry.Finger@lwfinger.net>
>>> Date		: 2009-01-23 23:52 (13 days old)
>>> References	: http://marc.info/?l=linux-kernel&m=123275478111406&w=4
>>> 		  http://marc.info/?l=linux-kernel&m=123254501314058&w=4
>>> Handled-By	: Mikael Pettersson <mikpe@it.uu.se>
>>> 		  Hugh Dickins <hugh@veritas.com>
>>> Patch		: http://marc.info/?l=linux-kernel&m=123254501314058&w=2
>> Yes, this does still need to be listed.  My initial patch for it was
>> not enough, but I think the three patches necessary have all now been
>> posted (though Sergei may rewrite mine).  I'm expecting Alan to gather
>> them together and send them in due course, but I believe he's occupied
>> with other stuff just at the moment.

I still have the problem as of 2.6.29-rc3-00634-g9be260a

Larry

