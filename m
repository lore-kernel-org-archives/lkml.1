Return-Path: <linux-kernel-owner+w=401wt.eu-S1757913AbYHAQrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757913AbYHAQrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 12:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756615AbYHAQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 12:45:44 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:46747 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756591AbYHAQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 12:45:43 -0400
Date: Fri, 1 Aug 2008 12:45:42 -0400
From: Theodore Tso <tytso@mit.edu>
To: Ryan Hope <rmh3093@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: reiser4 for 2.6.27-rc1
Message-ID: <20080801164541.GF8654@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Ryan Hope <rmh3093@gmail.com>, LKML <linux-kernel@vger.kernel.org>
References: <48f7fe350808010649l1111f48enbb6eca3cfcbba67f@mail.gmail.com> <20080801162548.GD8654@mit.edu> <48f7fe350808010934k32b9de09we657e57087a3e3a5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48f7fe350808010934k32b9de09we657e57087a3e3a5@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 12:34:53PM -0400, Ryan Hope wrote:
> Hmmm, removing the plugin support might not be so hard....  I might
> have to try this... I am not impressed with btrfs yet.

Well, if you're going to work on reiser4 (and I think there were other
people who had also expressed interest/plans to work on it; you might
try doing a search on the various mailing lists so you can coordinate
with them and avoid duplicating work), my suggestion to you would be
to find the comments that were made by the reviewers way back when,
and make sure those comments have been addressed.

Then, re-requests a code review, and promise that you won't abuse, and
insult the integrity and impugn the motivations of the reviewers like
Hans did, and hopefully after they review the code, fix those problems
as well.  Then you can try resubmitting for inclusion.

Best regards,

    	      	    	 	    	      - Ted
