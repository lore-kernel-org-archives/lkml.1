Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbXLEKhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbXLEKhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:37:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751552AbXLEKhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:37:33 -0500
Received: from ns.suse.de ([195.135.220.2]:38483 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbXLEKhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:37:32 -0500
Date: Wed, 5 Dec 2007 11:37:28 +0100
From: Nick Piggin <npiggin@suse.de>
To: =?iso-8859-1?Q?Hans-J=FCrgen?= Koch <hjk@linutronix.de>
Cc: akpm@linux-foundation.org, greg@kroah.com, linux-kernel@vger.kernel.org
Subject: Re: [patch 04/18] uio: nopage
Message-ID: <20071205103728.GF1114@wotan.suse.de>
References: <20071205071547.701344000@nick.local0.net> <20071205071627.143603000@nick.local0.net> <20071205110408.3eab9340@dilbert.local> <20071205101042.GC1114@wotan.suse.de> <20071205112500.2c97035f@dilbert.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071205112500.2c97035f@dilbert.local>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 11:25:00AM +0100, Hans-Jürgen Koch wrote:
> Am Wed, 5 Dec 2007 11:10:42 +0100
> schrieb Nick Piggin <npiggin@suse.de>:
> 
> > On Wed, Dec 05, 2007 at 11:04:08AM +0100, Hans-Jürgen Koch wrote:
> > > Am Wed, 05 Dec 2007 18:15:51 +1100
> > > schrieb npiggin@suse.de:
> > > 
> > > > Convert uio from nopage to fault.
> > > > 
> > > > Signed-off-by: Nick Piggin <npiggin@suse.de>
> > > > Cc: greg@kroah.com
> > > 
> > > Hi Nick,
> > > could you please add me to Cc: for UIO stuff:
> > > 
> > > Cc: hjk@linutronix.de
> > 
> > Sure, I'll try to remember in future. It would be helpful if you could
> > add an entry to MAINTAINERS?
> 
> Well, although I wrote a lot of UIO code and feel a bit responsible for
> it, I don't know if I can call myself an UIO maintainer. ATM, I think
> it's considered "driver core" and is therefore in Greg's domain.

If you're interested in reviewing patches for it, I think that's
valuable enough that we don't have to worry about formal titles ;)

Also, you can have more than one email address for a given MAINTAINERS
entry. So I'm sure Greg wouldn't mind if you were there too.

Thanks,
Nick

