Return-Path: <linux-kernel-owner+w=401wt.eu-S1755769AbZBHWEY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769AbZBHWEY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:04:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbZBHVx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:53:26 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50533 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754953AbZBHVxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:53:25 -0500
Date: Sun, 8 Feb 2009 16:53:21 -0500
From: Kyle McMartin <kyle@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Chuck Ebbert <cebbert@redhat.com>, Kyle McMartin <kyle@infradead.org>
Subject: Re: [Bug #12666] Build failure with latest -git: btrfs on ppc64
Message-ID: <20090208215321.GE11398@bombadil.infradead.org>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera> <sWhNs83kKPE.A.x-D.N20jJB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sWhNs83kKPE.A.x-D.N20jJB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 08, 2009 at 08:21:49PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12666
> Subject		: Build failure with latest -git: btrfs on ppc64
> Submitter	: Chuck Ebbert <cebbert@redhat.com>
> Date		: 2009-02-07 20:50 (2 days old)
> References	: http://marc.info/?l=linux-kernel&m=123404002114219&w=4
> 

Just fyi, patch here:
Subject: x86: spinlocks: define dummy __raw_spin_is_contended                   
Date: Sun, 8 Feb 2009 13:03:41 -0500                                            
Message-ID: <20090208180341.GC11398@bombadil.infradead.org>    

cheers, Kyle
