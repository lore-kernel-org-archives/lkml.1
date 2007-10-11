Return-Path: <linux-kernel-owner+w=401wt.eu-S1758075AbXJKQWc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758075AbXJKQWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 12:22:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXJKQWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 12:22:24 -0400
Received: from thunk.org ([69.25.196.29]:39502 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXJKQWX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 12:22:23 -0400
Date: Thu, 11 Oct 2007 12:22:19 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Crane, Matthew" <mcrane03@harris.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Aggregation in embedded context, is kernel GPL2
	prejudiceagainst embedded systems?
Message-ID: <20071011162219.GI10759@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Crane, Matthew" <mcrane03@harris.com>,
	Adrian Bunk <bunk@kernel.org>, linux-kernel@vger.kernel.org
References: <E496871456016F4CA8959BE4105D2A890E8D76@troe2k1.cs.myharris.net> <20071011151543.GX16424@stusta.de> <E496871456016F4CA8959BE4105D2A890E8D7C@troe2k1.cs.myharris.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E496871456016F4CA8959BE4105D2A890E8D7C@troe2k1.cs.myharris.net>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 12:06:14PM -0400, Crane, Matthew wrote:
> I wasn't sure how to describe what the people and groups with the
> mandate to defend open source software.  There are people and groups
> with such a mandate.

There is no such thing as "mandate".  If you are a copyright owner,
and you elect to be a hard*ss about enforcing the GPL, you can choose
to do so.  If you are not a copyright owner, all you can do is
pontificate with FAQ's about GPL....

> I'm asking if in a legal sense the grayness is affected by the
> constraints of the hw the kernel is being run on, and some attempt to
> quantify how the grayness is affected.  Of course it is not black and
> white and ultimately up to a judge. 

At the end of the day it all boils down to what is a derived work.  If
an object file which is designed to link into a kernel is a derived
work, then the GPL claims that it will infect across to that derived
work.  Whether or not it this is a case is a matter of much debate,
and as far as I know, no court has ever ruled on point regarding the
question of object files, dynamical linking, and whether or not that
would be a derived work or not.  It seems likely that the answer may
vary from one legal jurisdiction to another.  Hence, the only answer
that we can give which is useful is, "Take this off of LKML, and go
ask a lawyer."

Best regards,

						- Ted
