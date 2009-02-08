Return-Path: <linux-kernel-owner+w=401wt.eu-S1754205AbZBHWIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbZBHWIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753380AbZBHWI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:08:27 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39989 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753197AbZBHWI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:08:26 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kyle McMartin <kyle@infradead.org>
Subject: Re: [Bug #12666] Build failure with latest -git: btrfs on ppc64
Date: Sun, 8 Feb 2009 23:08:13 +0100
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-tst; KDE/4.2.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.x-D.N20jJB@chimera> <20090208215321.GE11398@bombadil.infradead.org>
In-Reply-To: <20090208215321.GE11398@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902082308.14366.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 08 February 2009, Kyle McMartin wrote:
> On Sun, Feb 08, 2009 at 08:21:49PM +0100, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12666
> > Subject		: Build failure with latest -git: btrfs on ppc64
> > Submitter	: Chuck Ebbert <cebbert@redhat.com>
> > Date		: 2009-02-07 20:50 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123404002114219&w=4
> > 
> 
> Just fyi, patch here:
> Subject: x86: spinlocks: define dummy __raw_spin_is_contended                   
> Date: Sun, 8 Feb 2009 13:03:41 -0500                                            
> Message-ID: <20090208180341.GC11398@bombadil.infradead.org>    

Thanks, updated the bug entry with this patch.

Rafael
