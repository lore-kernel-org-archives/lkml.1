Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbYE2Vjd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbYE2Vjd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 17:39:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754296AbYE2Vj0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 17:39:26 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59112
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752511AbYE2VjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 17:39:25 -0400
Date: Thu, 29 May 2008 14:39:21 -0700 (PDT)
Message-Id: <20080529.143921.34376298.davem@davemloft.net>
To: tytso@mit.edu
Cc: benh@kernel.crashing.org, James.Bottomley@HansenPartnership.com,
       ksummit-2008-discuss@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2008-discuss] Fixing the Kernel Janitors project
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080529211404.GH8065@mit.edu>
References: <20080529124548.GC8065@mit.edu>
	<20080529.135431.235149338.davem@davemloft.net>
	<20080529211404.GH8065@mit.edu>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Theodore Tso <tytso@mit.edu>
Date: Thu, 29 May 2008 17:14:04 -0400

> On Thu, May 29, 2008 at 01:54:31PM -0700, David Miller wrote:
> > Yes, process is important, but I'd say it deserved 1/3 of the summit
> > time, but not one minute more.
> 
> We were about 50-50 last time, roughly.  So let's see if there is
> consensus to dial it back this year, based on topics that people
> suggest.

Today at LinuxTAG, Thomas Gleixner and I tossed around the idea
that (assuming a 3 day event) we do tech stuff on day 1, process
stuff on day 2, and back to tech stuff on day 3.

The idea is that you hash out the initial impressions of your
ideas on day 1, your mind works on the problem in the background
on day 2, and they everyone has the answers on day 3 :-)

Another idea we discussed briefly was some kind of organized run
over the bugzilla entries.  And just to make it interesting we could
award some silly prize to whoever fixed the most interesting or
amusing bug during the bug-run, as voted by the attendees.
