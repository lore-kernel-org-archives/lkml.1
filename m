Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109AbZFERWk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109AbZFERWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 13:22:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751960AbZFERWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 13:22:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478AbZFERWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 13:22:32 -0400
Date: Fri, 5 Jun 2009 10:21:19 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
       Dave Airlie <airlied@linux.ie>, dri-devel@lists.sf.net,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] drm fixes
In-Reply-To: <21d7e9970906042259l56ba3382wa3413132fc2d8b10@mail.gmail.com>
Message-ID: <alpine.LFD.2.01.0906051019520.6847@localhost.localdomain>
References: <alpine.DEB.2.00.0906040438210.7074@skynet.skynet.ie>  <20090605054231.GA2212@gentoox2.trippelsdorf.de> <21d7e9970906042259l56ba3382wa3413132fc2d8b10@mail.gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 5 Jun 2009, Dave Airlie wrote:

> On Fri, Jun 5, 2009 at 3:42 PM, Markus
> Trippelsdorf<markus@trippelsdorf.de> wrote:
> > On Thu, Jun 04, 2009 at 04:39:50AM +0100, Dave Airlie wrote:
> >>
> >> Hi Linus,
> >>
> >> Please pull the 'drm-fixes' branch from
> >> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6.git drm-fixes
> 
> 
> Okay Linus if you do pull this can you revert
> 6c51d1cfa0a370b48a157163340190cf5fd2346b
> 
> that works fine on my intel hw but seems to have a bad effect on radeon.

Grr.

That pull request probably shouldn't have been sent to me at all. It's 
clearly almost totally untested, and it was damn late in the -rc series.

Am I going to be in the situation that I simply can't safely pull from you 
any more after -rc2 or so? This is _not_ working.

			Linus
