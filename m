Return-Path: <linux-kernel-owner+w=401wt.eu-S1754627AbYDIMdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbYDIMdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 08:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751928AbYDIMdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 08:33:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60929 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbYDIMdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:33:10 -0400
Date: Wed, 9 Apr 2008 08:30:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Huang, Ying" <ying.huang@intel.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, nigel@nigel.suspend2.net,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Kexec Mailing List <kexec@lists.infradead.org>
Subject: Re: [PATCH -mm] kexec jump -v9
Message-ID: <20080409123028.GC15469@redhat.com>
References: <1204773188.4707.109.camel@caritas-dev.intel.com> <20080409093444.GA6957@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080409093444.GA6957@ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2008 at 11:34:45AM +0200, Pavel Machek wrote:
> Hi!
> 
> > This is a minimal patch with only the essential features. All
> > additional features are split out and can be discussed later. I think
> > it may be easier to get consensus on this minimal patch.
> 
> 
> Eric, can we get some reviewing/merging going on? Patches seem pretty
> clean to me, and I do not think holding them outside mainline will
> help them... they will only get bigger and harder to merge :-(.
> 

Pavel, I think Huang is working on v10 based on feedback last time. So
probably we can get into line by line review in next version.

Thanks
Vivek
