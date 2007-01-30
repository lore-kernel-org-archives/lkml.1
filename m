Return-Path: <linux-kernel-owner+w=401wt.eu-S1751831AbXA3W1K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbXA3W1K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 17:27:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbXA3W1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 17:27:10 -0500
Received: from caffeine.uwaterloo.ca ([129.97.134.17]:39223 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbXA3W1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 17:27:08 -0500
Date: Tue, 30 Jan 2007 17:27:07 -0500
To: Roland Dreier <rdreier@cisco.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
Message-ID: <20070130222707.GG7584@csclub.uwaterloo.ca>
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com> <20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com> <20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adazm80p4qp.fsf@cisco.com>
User-Agent: Mutt/1.5.9i
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 30, 2007 at 01:46:38PM -0800, Roland Dreier wrote:
> I disagree -- Linux today gets drivers not just from volunteers
> writing drivers from specs, but also from vendors writing drivers and
> volunteers writing drivers via reverse engineering.  And many of those
> drivers don't work on every platform and aren't supported by
> enterprise distros.  And when the community loses interest, drivers
> are left to bitrot.

I would much rather see a driver bit rot due to lack of interest than
see hardware go to the scrap heap because the vendor stoped caring about
it and you are SOL.  Happens every time a new windows version comes out.
lots of working hardware suddenly becomes useless.  At least on linux I
can keep using it if I want to until I decide not to try and maintain
the driver (if no one else is doing it).  A driver with bitrot is a lot
better than no driver at all.

--
Len Sorensen
