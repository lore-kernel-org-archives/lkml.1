Return-Path: <linux-kernel-owner+w=401wt.eu-S1753495AbYIZTFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753495AbYIZTFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 15:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbYIZTFG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 15:05:06 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35151 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbYIZTFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 15:05:05 -0400
Date: Fri, 26 Sep 2008 15:04:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: rt2400-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Paul Eddington <eddingtonpaul@googlemail.com>,
       linux-kernel@vger.kernel.org, Iwo Mergler <iwo@call-direct.com.au>
Subject: Re: [Rt2400-devel] Bug in rt2x00 rt73usb driver in latest git
	kernel
Message-ID: <20080926190408.GE3483@tuxdriver.com>
References: <762793250809241102n61ea8f00kca8138bc3c8df2e6@mail.gmail.com> <200809261452.28482.rjw@sisk.pl> <200809262024.57874.IvDoorn@gmail.com> <200809262053.39930.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200809262053.39930.IvDoorn@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2008 at 08:53:39PM +0200, Ivo van Doorn wrote:
> On Friday 26 September 2008, Ivo van Doorn wrote:
> > On Friday 26 September 2008, Rafael J. Wysocki wrote:

> > > Well, according to the information I've received from Paul this particular
> > > problem is a regression from 2.6.26, so it's been added to the list of recent
> > > regressions.
> > 
> > Seriously, this error message is the most annoying rt2x00 error message _ever_.
> > It should have been fixed 3 kernels ago, but it keeps popping up again and again.
> > 
> > Paul, what is the git commit id with which you encountered this bug?
> 
> Oh and please test rt2x00.git as well, since some patches which should fix this issue
> are in there (and in wireless-testing.git) but not in Linus' tree since they are scheduled
> for 2.6.28.

Can you identify which fixes those are likely to be?

John

P.S.  Of course, as you pointed out this isn't a new bug.  Since it
existed in 2.6.26, then technically it isn't a regression under
current merging practices as I understand them.
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
