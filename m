Return-Path: <linux-kernel-owner+w=401wt.eu-S1763144AbXHaAUM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763144AbXHaAUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 20:20:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754831AbXHaAUB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 20:20:01 -0400
Received: from ozlabs.org ([203.10.76.45]:34502 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298AbXHaAUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 20:20:00 -0400
Subject: Re: [Lguest] [PATCH] modify lguest console to support multiple
	hvc's
From: Rusty Russell <rusty@rustcorp.com.au>
To: Eric Van Hensbergen <ericvh@ericvh.homeip.net>
Cc: lguest@ozlabs.org, linux-kernel@vger.kernel.org,
       Eric Van Hensbergen <ericvh@ericvh-desktop.austin.ibm.com>
In-Reply-To: <11884991234068-git-send-email-ericvh@opteron.9grid.us>
References: <11884991234068-git-send-email-ericvh@opteron.9grid.us>
Content-Type: text/plain
Date: Fri, 31 Aug 2007 10:19:35 +1000
Message-Id: <1188519575.6004.15.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-30 at 13:38 -0500, Eric Van Hensbergen wrote:
> From: Eric Van Hensbergen <ericvh@ericvh-desktop.austin.ibm.com>
> 
> This was a quick modification I did of lguest to be able to support multiple
> HVC channels for some experiements I was doing.  I'm not sure if this is more
> generally useful, so I'm posting it to the list in case someone else has a
> need for it.
> 
> Signed-off-by: Eric Van Hensbergen <ericvh@gmail.com>

Hi Eric,

	This is cool!  Great that it's useful for you.  What do the other
consoles look like from inside the guest?

Cheers,
Rusty.


