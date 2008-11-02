Return-Path: <linux-kernel-owner+w=401wt.eu-S1754526AbYKBTOu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526AbYKBTOu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2008 14:14:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752260AbYKBTOm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Nov 2008 14:14:42 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:58232 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbYKBTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2008 14:14:41 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <490DFBFE.4000307@s5r6.in-berlin.de>
Date: Sun, 02 Nov 2008 20:14:06 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.17) Gecko/20081027 SeaMonkey/1.1.12
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: [Bug #11824] raw1394: possible deadlock if accessed by multithreaded
 app
References: <603i_OdVYPF.A.7_D.mjeDJB@chimera> <wOAXuecskPD.A.stH.KleDJB@chimera>
In-Reply-To: <wOAXuecskPD.A.stH.KleDJB@chimera>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote at LKML:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.27.  Please verify if it still should be listed and let me know
> (either way).

Yes, it is still open.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11824
> Subject		: raw1394: possible deadlock if accessed by multithreaded app
> Submitter	: Stefan Richter <stefan-r-bz@s5r6.in-berlin.de>
> Date		: 2008-10-25 02:08 (9 days old)
> Handled-By	: Stefan Richter <stefanr@s5r6.in-berlin.de>
> Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=11824#c3

The patch has been committed to linux1394-2.6.git (commit
638570b54346f140bc09b986d93e76025d35180f in the branches misc, for-next,
master) and I plan to send a pull request in a few days if I receive no
objections.
-- 
Stefan Richter
-=====-==--- =-== ---=-
http://arcgraph.de/sr/
