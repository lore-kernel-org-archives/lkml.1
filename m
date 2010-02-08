Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab0BHSl6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 13:41:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27167 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842Ab0BHSl5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 13:41:57 -0500
Message-ID: <4B705AEA.9060303@redhat.com>
Date: Mon, 08 Feb 2010 16:41:46 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux Media Mailing List <linux-media@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.2.33] Fix regressions on dvb demux
References: <4B703E1D.8090705@redhat.com> <alpine.LFD.2.00.1002081011060.3829@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1002081011060.3829@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 8 Feb 2010, Mauro Carvalho Chehab wrote:
>> are available in the git repository at:
>>
>>   ssh://linuxtv.org/git/fixes.git v4l_for_linus
> 
> I don't have ssh access to that thing, and git:// doesn't work.

Sorry for the bad link. We've recently moved our master development trees
to git also, in order to work internally the same way as upstream.

The git URL is:
	git://linuxtv.org/fixes.git v4l_for_linus

> 
> You probably meant
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6
> 
> but it's not pushed out to there yet.

My push should be going simultaneously to both remotes, but it seems that
only the replica at linuxtv got updated. I'll need to review my .git/config
in order to fix it.

Anyway, both places are now ok. So, you can pull from:

	ssh://master.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git v4l_for_linus

-- 

Cheers,
Mauro
