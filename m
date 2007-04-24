Return-Path: <linux-kernel-owner+w=401wt.eu-S1161703AbXDXHwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161703AbXDXHwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 03:52:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161704AbXDXHwZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 03:52:25 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:18638 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161703AbXDXHwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 03:52:23 -0400
Subject: Re: [PATCH 0/9] Kconfig: cleanup s390 v2.
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, mb@bu3sch.de,
       linville@tuxdriver.com, arnd@arndb.de, maxextreme@gmail.com,
       gregkh@suse.de
In-Reply-To: <20070423104534.51bac974.akpm@linux-foundation.org>
References: <20070423141123.GA21174@skybase>
	 <20070423104534.51bac974.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Organization: IBM Corporation
Date: Tue, 24 Apr 2007 09:52:39 +0200
Message-Id: <1177401159.22970.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-23 at 10:45 -0700, Andrew Morton wrote:
> > Andrew: I plan to add patches 1-5 to the for-andrew branch of the
> > git390 repository if that is fine with you. The only thing that will
> > be missing in the tree is the patch that disables wireless for s390.
> > The code does compile but without hardware it is mute to have the
> > config options. I'll wait until the git-wireless.patch is upstream.
> > Patches 7-9 depend on patches found in -mm.
> > 
> 
> umm, OK.  If it's Ok I think I'll duck it for now: -mm is full.
> 
> Over-full, really: I've been working basically continuously since Friday
> getting the current dungpile to compile and boot, and it's still miles away
> from that.

I understand. I'll wait until -mm is a little bit smaller again. It is
just that someday I want to finish with the Kconfig cleanup, it has been
sitting on my harddriver for ages now.

-- 
blue skies,              IBM Deutschland Entwicklung GmbH
   Martin                Vorsitzender des Aufsichtsrats: Johann Weihen
                         Geschäftsführung: Herbert Kircher
Martin Schwidefsky       Sitz der Gesellschaft: Böblingen
Linux on zSeries         Registergericht: Amtsgericht Stuttgart,
   Development           HRB 243294

"Reality continues to ruin my life." - Calvin.


