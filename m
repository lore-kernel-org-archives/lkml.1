Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbXLSDMm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbXLSDMm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 22:12:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXLSDMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 22:12:35 -0500
Received: from relay2.sgi.com ([192.48.171.30]:41690 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751431AbXLSDMe (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 22:12:34 -0500
Date: Wed, 19 Dec 2007 14:12:25 +1100
From: David Chinner <dgc@sgi.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Chinner <dgc@sgi.com>, Lachlan McIlroy <lachlan@sgi.com>,
       linux-kernel@vger.kernel.org, xfs@oss.sgi.com,
       akpm@linux-foundation.org
Subject: Re: [GIT PULL] XFS update for 2.6.24-rc6
Message-ID: <20071219031225.GB4612@sgi.com>
References: <20071218065911.EDC8158C4C0F@chook.melbourne.sgi.com> <20071219004126.GS4396912@sgi.com> <alpine.LFD.0.9999.0712181718430.21557@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0712181718430.21557@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 05:19:04PM -0800, Linus Torvalds wrote:
> 
> 
> On Wed, 19 Dec 2007, David Chinner wrote:
> >
> > On Tue, Dec 18, 2007 at 05:59:11PM +1100, Lachlan McIlroy wrote:
> > > Please pull from the for-linus branch:
> > >     git pull git://oss.sgi.com:8090/xfs/xfs-2.6.git for-linus
> > 
> > Linus, please don't pull this yet. A problem has been found in
> > the dirent fix, and we've just fixed another mknod related regression
> > so we've got another couple of fixes still to go in XFS for 2.6.24.
> 
> Too late, it's already long since pulled.

Ok, we'll just have to get the fixes to you ASAP.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
