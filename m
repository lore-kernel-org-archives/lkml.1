Return-Path: <linux-kernel-owner+w=401wt.eu-S1758679AbXLUWIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758679AbXLUWIf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 17:08:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754563AbXLUWI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 17:08:29 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49355 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476AbXLUWI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 17:08:28 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Johannes Weiner <hannes@saeurebad.de>
Subject: Re: 2.6.24-rc5-git7: Reported regressions from 2.6.23
Date: Fri, 21 Dec 2007 23:27:56 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Dave Jones <davej@codemonkey.org.uk>
References: <200712210212.02666.rjw@sisk.pl> <87d4t05f5a.fsf@saeurebad.de>
In-Reply-To: <87d4t05f5a.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712212327.57268.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 21 of December 2007, Johannes Weiner wrote:
> Hi,
> 
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > This message contains a list of some regressions from 2.6.23 reported since
> > 2.6.24-rc1 was released, for which there are no fixes in the mainline I know
> > of.  If any of them have been fixed already, please let me know.
> >
> > If you know of any other unresolved regressions from 2.6.23, please let me know
> > either and I'll add them to the list.  Also, please let me know if any of the
> > entries below are invalid.
> 
> I still have a bug with cpufreq when using ondemand governor as default.

Added as http://bugzilla.kernel.org/show_bug.cgi?id=9615 .

Thanks,
Rafael
