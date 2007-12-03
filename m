Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbXLCJQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbXLCJQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 04:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbXLCJQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 04:16:31 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:5772 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbXLCJQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 04:16:30 -0500
Subject: Re: Linux 2.6.22.14
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
In-Reply-To: <20071126220020.GA10703@suse.de>
References: <20071121175644.GA1329@kroah.com>
	 <20071121175701.GB1329@kroah.com>
	 <1196000495.18901.8.camel@sven.thebigcorporation.com>
	 <20071126220020.GA10703@suse.de>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 01:16:16 -0800
Message-Id: <1196673376.11841.6.camel@sven.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-11-26 at 14:00 -0800, Greg KH wrote:
> On Sun, Nov 25, 2007 at 06:21:35AM -0800, Sven-Thorsten Dietrich wrote:
> > Hi Greg,
> > 
> > I think this hunk in the 2.6.22.14 stable patch may be a mis-patch --
> > compared to Linus's current git -- the new code should be inserted below
> > the while loop that follows.
> > 
> > Also see commit 9f96cb1e8bca179a92afa40dfc3c49990f1cfc71
> 
> Hm, I'm confused.  Why is this a mis-patch?
> 

The implementation in 2.6.22.14 is just divergent in from mainline's,
and looked peculiar in context of what some RT bugfix was doing.


Sorry for the noise. 

Sven

> Care to send me a fix against 2.6.22.14 that solves this issue?
> 
> thanks,
> 
> greg k-h

