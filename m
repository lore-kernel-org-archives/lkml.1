Return-Path: <linux-kernel-owner+w=401wt.eu-S1757449AbYCKMXJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449AbYCKMXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 08:23:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756587AbYCKMWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 08:22:53 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:36432 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756100AbYCKMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 08:22:49 -0400
Message-ID: <47D67992.8010308@s5r6.in-berlin.de>
Date: Tue, 11 Mar 2008 13:22:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Meyer <thomas@m3y3r.de>
CC: LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: Re: 2.6.25-rc5: Reported regressions from 2.6.24
References: <200803110014.52985.rjw@sisk.pl>
In-Reply-To: <200803110014.52985.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10080
> Subject		: 2.6.25-rc2: ohci1394 problem
> Submitter	: Thomas Meyer <thomas@m3y3r.de>
> Date		: 2008-02-20 08:47
> References	: http://lkml.org/lkml/2008/2/20/58
> Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>

Thomas wrote on 2008-02-25:
''So i did a "make clean" and a "make" (not a make
-j3 as i use to do) and recompiled 2.6.25-rc3 and now it works again.
Case closed under strange error.''

I have closed the bugzilla bug now.
-- 
Stefan Richter
-=====-==--- --== -=-==
http://arcgraph.de/sr/
