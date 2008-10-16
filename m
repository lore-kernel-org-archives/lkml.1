Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYJPPbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYJPPbj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 11:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYJPPbb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 11:31:31 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209AbYJPPba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 11:31:30 -0400
Date: Thu, 16 Oct 2008 11:30:53 -0400
From: Bill Nottingham <notting@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Adrian Bunk <bunk@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] Kernel version numbering scheme change
Message-ID: <20081016153053.GJ5834@nostromo.devel.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>, Adrian Bunk <bunk@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20081016002509.GA25868@kroah.com> <20081016124943.GE23630@cs181140183.pp.htv.fi> <20081016151748.GA31075@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081016151748.GA31075@kroah.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH (greg@kroah.com) said: 
> Distros properly patch things and backport "urgent OpenSSL security
> updates" to older versions of packages, so they would not run into this
> problem.
> 
> Newer releases would run into this problem, but as almost all distros
> have huge, easy to run, build systems, a change like this would show up
> immediately and be fixed in a matter of hours, with the needed fixes
> being pushed upstream to the various packages as needed.
> 
> So I really don't think this is much of a problem.
> 
> It's interesting that openssl doesn't just check for Linux 1.x and
> assumes that Linux 9.23.12 will work just fine with what they are doing :)

Is it really worth the effort of having any such upstream have to
quickly patch and release, when the only benefit listed (earlier in
this thread) was to inform people how old their kernel is?

Bill
