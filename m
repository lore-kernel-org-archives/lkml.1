Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbZEGHto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbZEGHto (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 03:49:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752193AbZEGHtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 03:49:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443AbZEGHtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 03:49:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
X-Fcc: ~/Mail/linus
Cc: linux-kernel@vger.kernel.org
Subject: Re: [FOR REVIEW, PATCH 2/2] introduce "struct wait_opts" to
	simplify do_wait() pathes
In-Reply-To: Oleg Nesterov's message of  Thursday, 7 May 2009 09:40:03 +0200 <20090507074003.GA17688@redhat.com>
References: <20090506053324.GA31988@redhat.com>
	<20090506200949.4FF6CFC39E@magilla.sf.frob.com>
	<20090507064559.GC15220@redhat.com>
	<20090507072003.8E0ACFC39E@magilla.sf.frob.com>
	<20090507074003.GA17688@redhat.com>
X-Zippy-Says: TAPPING?  You POLITICIANS!  Don't you realize that the END of the
    ``Wash Cycle'' is a TREASURED MOMENT for most people?!
Message-Id: <20090507074931.01E5EFC39E@magilla.sf.frob.com>
Date: Thu,  7 May 2009 00:49:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I must admit, I do not agree. I feel the opposite. Yes we have 2 repeated
> assignment blocks, but there are not exactly equal, and imho the difference
> is more visible this way.

Ok, whatever.

> That said. This is not the technical issue, I can't "prove" I am right and
> of course I may be wrong. I think we should follow the "maintaner is always
> right" rule ;)
> 
> I'll send this change as another cleanup on top of the new series.

Nah.  The "he who wrote the last patch is the real maintainer" rule is
better.  If the theoretical pitfalls I imagine ever materialize under our
feet, I'll tell everybody it was your fault (git will, anyway). ;-)


Thanks,
Roland
