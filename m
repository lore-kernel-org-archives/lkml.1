Return-Path: <linux-kernel-owner+w=401wt.eu-S933294AbZDHPK5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933294AbZDHPK5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 11:10:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757196AbZDHPKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 11:10:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:34054 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982AbZDHPKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 11:10:44 -0400
Date: Wed, 8 Apr 2009 09:10:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Julia Lawall <julia@diku.dk>
Cc: Jack Stone <jwjstone@fastmail.fm>, Ingo Molnar <mingo@elte.hu>,
       Bert Wesarg <bert.wesarg@googlemail.com>, linux-kernel@vger.kernel.org,
       jeff@garzik.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 54/56] x86: Remove void casts
Message-ID: <20090408151032.GB20983@parisc-linux.org>
References: <49DCAE97.8040602@fastmail.fm> <20090408140637.GC12931@elte.hu> <49DCB140.7000603@fastmail.fm> <20090408144055.GH12931@elte.hu> <49DCB8C5.4090108@fastmail.fm> <20090408144842.GK12931@elte.hu> <49DCBA61.8060507@fastmail.fm> <20090408145715.GO12931@elte.hu> <49DCBBDF.4040603@fastmail.fm> <Pine.LNX.4.64.0904081705390.9554@pc-004.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0904081705390.9554@pc-004.diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 08, 2009 at 05:06:57PM +0200, Julia Lawall wrote:
> This can be helpful: http://lwn.net/Articles/284469/
> 
> It's a bit out of date, though, because git-blame seems to have 
> disappeared as a command.

Are you just getting confused by the removal of the 'git-foo' form?

'git blame' works, and I see:
$ dpkg -S /usr/lib/git-core/git-blame 
git-core: /usr/lib/git-core/git-blame

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
