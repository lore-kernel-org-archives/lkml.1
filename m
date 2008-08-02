Return-Path: <linux-kernel-owner+w=401wt.eu-S1757192AbYHBPVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757192AbYHBPVx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 11:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbYHBPVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 11:21:45 -0400
Received: from ns1.suse.de ([195.135.220.2]:47988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbYHBPVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 11:21:45 -0400
Date: Sat, 2 Aug 2008 17:21:43 +0200
From: Karsten Keil <kkeil@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Subject: Re: [PATCH] mISDN cleanup user interface
Message-ID: <20080802152143.GA14457@pingi.kke.suse.de>
References: <20080729195637.GB25929@pingi.kke.suse.de> <alpine.LFD.1.10.0808011020000.3277@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808011020000.3277@nehalem.linux-foundation.org>
Organization: SuSE Linux AG
X-Operating-System: Linux 2.6.16.54-0.2.5-smp x86_64
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 10:21:29AM -0700, Linus Torvalds wrote:
> 
> 
> On Tue, 29 Jul 2008, Karsten Keil wrote:
> >
> > Please pull from git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master
> 
> Grr. What's the status of this now? That branch is unpullable - you've put 
> pretty much the same patch in twice, reverted it once, and added some 
> merge into it too. So of the five commits, less than half are actually 
> useful and worthwhile.
> 

I created a new clean merge tree, it contain the last 4 patches I posted
some minutes ago.

git://git.kernel.org/pub/scm/linux/kernel/git/kkeil/ISDN-2.6.git master


-- 
Karsten Keil
SuSE Labs
ISDN and VOIP development
SUSE LINUX Products GmbH, Maxfeldstr.5 90409 Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
