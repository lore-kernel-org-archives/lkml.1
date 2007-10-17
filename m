Return-Path: <linux-kernel-owner+w=401wt.eu-S936148AbXJQDCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936148AbXJQDCE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 23:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbXJQDBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 23:01:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58456 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751220AbXJQDBw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 23:01:52 -0400
Date: Tue, 16 Oct 2007 23:01:49 -0400
From: Dave Jones <davej@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Distinguishing releases from pre-rc snapshots
Message-ID: <20071017030149.GC3397@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Pavel Roskin <proski@gnu.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1192587763.3672.24.camel@dv> <20071017023406.GA3397@redhat.com> <1192589117.3672.31.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1192589117.3672.31.camel@dv>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 10:45:17PM -0400, Pavel Roskin wrote:
 > 
 > On Tue, 2007-10-16 at 22:34 -0400, Dave Jones wrote:
 > > On Tue, Oct 16, 2007 at 10:22:43PM -0400, Pavel Roskin wrote:
 > > 
 > >  > It would be nice to establish a rule to increment the version number
 > >  > immediately after the kernel release and have a suffix to indicate that
 > >  > it's a pre-rc version.  "rc0" is my personal favorite.
 > > 
 > > fwiw, rc0 is also what the Fedora kernel uses for versioning when we're
 > > shipping pre-rc1 kernels.
 > 
 > Thanks!  I didn't think of the possibility of anyone distributing
 > precompiled kernels from the "pre-rc" window, but if Fedora does it
 > (hopefully for beta-testers only), it should be absolutely clear that
 > it's not just a release with some minor fixes.

yeah, this is just in our 'development' pool (also known as 'rawhide')
Proper releases only ever get full point releases + -stable as updates.

	Dave

-- 
http://www.codemonkey.org.uk
