Return-Path: <linux-kernel-owner+w=401wt.eu-S933750AbYDQRoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933750AbYDQRoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761544AbYDQRoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:44:13 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:44692 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753375AbYDQRoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:44:11 -0400
Date: Thu, 17 Apr 2008 19:44:40 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: Bart Van Assche <bart.vanassche@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>, rufus-azrael@numericable.fr
Subject: Re: 2.6.25 section mismatches
Message-ID: <20080417174440.GA14864@uranus.ravnborg.org>
References: <e2e108260804170246i673a2e08q333eeae48467ed4@mail.gmail.com> <e2e108260804170949p6cceb4em78455d8dc5ff7261@mail.gmail.com> <20080417170149.GC17220@sequoia.sous-sol.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080417170149.GC17220@sequoia.sous-sol.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2008 at 10:01:49AM -0700, Chris Wright wrote:
> * Bart Van Assche (bart.vanassche@gmail.com) wrote:
> > On Thu, Apr 17, 2008 at 11:46 AM, Bart Van Assche
> > <bart.vanassche@gmail.com> wrote:
> > > Apparently there is a significant number of section mismatches in the
> > >  2.6.25 kernel. These were already reported against 2.6.25-rc1 and are
> > >  still present in the final 2.6.25 release. These section mismatches
> > >  show up at least on the i386 and x86_64 architectures. Maybe it's a
> > >  good idea before a patch is merged not only to check whether the patch
> > >  applies cleanly but also to check whether it doesn't create any new
> > >  section mismatches ?
> > >
> > >  See also http://bugzilla.kernel.org/show_bug.cgi?id=9974.
> > 
> > Who should look into this ?
> 
> Sam, any of these look familiar (or put another way...are there still
> outstanding section mismatch fixes in -mm)?

>From a quick scan I will say that at least half of these have pending fixes in -mm.
I'm looking forward to see where we are after Andrew's first merge.

	Sam
