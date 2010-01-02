Return-Path: <linux-kernel-owner+w=401wt.eu-S1751977Ab0ABTYG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab0ABTYG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 14:24:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753Ab0ABTYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 14:24:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:33181 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab0ABTYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 14:24:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gVyn05tWts8iRMGM+d3yHGtfIB6OupxqSByAA2o4lhXF76fiCZbctd/7NWdUVJxJ+p
         T3QK9bssfiWcra18kbT3nTrEoy0Phtuo/pL1xOQzEfsu55vOWuawVZcDhpK6nFsUmb1z
         7pcdlqNNs9FBjzxf4iNQskwMH0JEl7RxRiI/8=
Date: Sat, 2 Jan 2010 20:24:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Christian Kujau <lists@nerdbynature.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>
Subject: Re: [GIT PULL] reiserfs fixes
Message-ID: <20100102192358.GE5076@nowhere>
References: <1262395636-8647-1-git-send-regression-fweisbec@gmail.com> <alpine.LFD.2.00.1001021118420.3630@localhost.localdomain> <alpine.LFD.2.00.1001021119570.3630@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1001021119570.3630@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 02, 2010 at 11:21:51AM -0800, Linus Torvalds wrote:
> 
> 
> On Sat, 2 Jan 2010, Linus Torvalds wrote:
> > 
> > Should 2.6.32-stable merge this branch too?
> 
> Never mind, none of the reiserfs bkl-removal went into 2.6.32. We had some 
> other BKL work that got in there, but all the reiserfs stuff is 
> post-2.6.32 only, I guess.
> 
> 		Linus


Exactly.

