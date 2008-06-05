Return-Path: <linux-kernel-owner+w=401wt.eu-S1761451AbYFEVe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761451AbYFEVe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 17:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752899AbYFEVes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 17:34:48 -0400
Received: from 2605ds1-ynoe.1.fullrate.dk ([90.184.12.24]:39260 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752171AbYFEVer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 17:34:47 -0400
Message-ID: <48485BEB.6030107@krogh.cc>
Date: Thu, 05 Jun 2008 23:34:35 +0200
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ian Kent <raven@themaw.net>, Al Viro <viro@ZenIV.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.26-rc4
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>  <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>  <20080603095713.GR28946@ZenIV.linux.org.uk>  <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk>  <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>  <20080603104035.GT28946@ZenIV.linux.org.uk>  <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>  <20080603105258.GV28946@ZenIV.linux.org.uk>  <1212499623.3025.46.camel@raven.themaw.net>  <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org> <1212651099.3047.44.camel@raven.themaw.net> <alpine.LFD.1.10.0806051427310.3473@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806051427310.3473@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Thu, 5 Jun 2008, Ian Kent wrote:
>> Keep in mind this doesn't address any other autofs4 issues but I it
>> should allow us to identify if this was in fact the root cause of the
>> problem Jesper reported.
> 
> Jesper, can you test this? I think you said you could trigger this in ~24 
> hours or so? I'd love to have some testing of some heavy autofs user. Even 
> if it's not a guarantee of a fix (due to reproducing the bug not being 
> entirely trivial), at least I'd like to know that it doesn't introduce any 
> obvious new problems either..

Yes, I'll apply it an report back. Dont expect anything before early 
next week.

Jesper
-- 
Jesper
