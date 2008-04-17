Return-Path: <linux-kernel-owner+w=401wt.eu-S934418AbYDQRC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934418AbYDQRC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 13:02:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755747AbYDQRCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 13:02:18 -0400
Received: from sous-sol.org ([216.99.217.87]:46756 "EHLO sous-sol.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbYDQRCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 13:02:17 -0400
Date: Thu, 17 Apr 2008 10:01:49 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <greg@kroah.com>, Chris Wright <chrisw@sous-sol.org>,
       rufus-azrael@numericable.fr, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.25 section mismatches
Message-ID: <20080417170149.GC17220@sequoia.sous-sol.org>
References: <e2e108260804170246i673a2e08q333eeae48467ed4@mail.gmail.com> <e2e108260804170949p6cceb4em78455d8dc5ff7261@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2e108260804170949p6cceb4em78455d8dc5ff7261@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Bart Van Assche (bart.vanassche@gmail.com) wrote:
> On Thu, Apr 17, 2008 at 11:46 AM, Bart Van Assche
> <bart.vanassche@gmail.com> wrote:
> > Apparently there is a significant number of section mismatches in the
> >  2.6.25 kernel. These were already reported against 2.6.25-rc1 and are
> >  still present in the final 2.6.25 release. These section mismatches
> >  show up at least on the i386 and x86_64 architectures. Maybe it's a
> >  good idea before a patch is merged not only to check whether the patch
> >  applies cleanly but also to check whether it doesn't create any new
> >  section mismatches ?
> >
> >  See also http://bugzilla.kernel.org/show_bug.cgi?id=9974.
> 
> Who should look into this ?

Sam, any of these look familiar (or put another way...are there still
outstanding section mismatch fixes in -mm)?

thanks,
-chris
