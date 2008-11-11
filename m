Return-Path: <linux-kernel-owner+w=401wt.eu-S1753963AbYKKWaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963AbYKKWaa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 17:30:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYKKWaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 17:30:21 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:48887 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbYKKWaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 17:30:21 -0500
Date: Tue, 11 Nov 2008 17:30:16 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: [0/2] Hibernation patches for suspend branch (was: Re: [PATCH
 -next] Hibernate: Take overlapping zones into account)
In-reply-to: <200811112130.26074.rjw@sisk.pl>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Message-id: <alpine.LFD.2.00.0811111728370.4480@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <200811081356.13060.rjw@sisk.pl>
 <alpine.LFD.2.00.0811111300580.4480@localhost.localdomain>
 <200811112130.26074.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




> OK, here you go.  The following two messages contain the updated patches

thanks, i've stashed them on the suspend branch.

I assume you'll be replying to nigel and that there
is plenty of time before .29 to revise if necessary.

> (still, 4 out of the 5 checkpatch.pl "errors" in the first patch were plain
> wrong IMO).

send that observation to the checkpatch maintainers then.

thanks,
-len


