Return-Path: <linux-kernel-owner+w=401wt.eu-S932689AbXJQLm3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932689AbXJQLm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 07:42:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758795AbXJQLmS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 07:42:18 -0400
Received: from twin.jikos.cz ([213.151.79.26]:36409 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758765AbXJQLmR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 07:42:17 -0400
Date: Wed, 17 Oct 2007 13:42:04 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: 2.6.23-mm1
In-Reply-To: <20071017183626.70bdd13e.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <Pine.LNX.4.64.0710171340580.18815@twin.jikos.cz>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
 <20071017160101.4dde7223.kamezawa.hiroyu@jp.fujitsu.com>
 <Pine.LNX.4.64.0710171108090.18815@twin.jikos.cz>
 <20071017183626.70bdd13e.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Oct 2007, KAMEZAWA Hiroyuki wrote:

> > Oh well, this causes more trouble that I have ever imagined ... I will 
> > look into it, thanks a lot for the report. Andrew, please drop this 
> > one again, I will fix it up.
> Maybe this can be fix.

Hi Kame,

yes, this looks correct to me. Did you verify that it makes the problem 
you are seeing go away?

I will do some more testing. Unfortunately, I am afraid it is a bit late 
for 2.6.24.

Thanks,

-- 
Jiri Kosina
