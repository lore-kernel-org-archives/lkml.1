Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYEAFfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYEAFfh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 01:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751814AbYEAFf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 01:35:27 -0400
Received: from 1wt.eu ([62.212.114.60]:3665 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751009AbYEAFf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 01:35:27 -0400
Date: Thu, 1 May 2008 07:35:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080501053505.GB18597@1wt.eu>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <48191D43.5010305@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48191D43.5010305@goop.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 06:30:43PM -0700, Jeremy Fitzhardinge wrote:
> Linus Torvalds wrote:
> >  And I think publicly announced git trees and -mm and linux-next are 
> >  great partly because they end up doing that same thing. I heartily 
> >  encourage submaintainers to always Cc: linux-kernel when they send me a 
> >  "please pull" request - I don't know if anybody else ever really pulls 
> >  that tree, but I do think that it's very healthy to write that message 
> >  and think of it as a publication event. ]
> >  
> 
> And, ideally, they would have posted the changes as patches to the list 
> for review anyway, so there shouldn't be anything surprising in that pull...

yes, it's something which has been disappearing since use of bk then git.
It would be impratical and useless to post everything during the merge
window now, but if we can get everyone to pass through linux-next, the
posts will be evenly distributed and it would make sense to require
everyone to post their changes to the list at the same time. Right now,
some developers already always post their changes. Jeff, Greg and
Bartlomiej come to mind, and I must say that I'm always interested in
performing a quick look, just in case something really obvious catches
my attention (which never happens).

Willy

