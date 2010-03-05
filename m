Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab0CESGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 13:06:21 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46222 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab0CESGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 13:06:20 -0500
Date: Fri, 5 Mar 2010 19:05:56 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       skeggsb@gmail.com, torvalds@linux-foundation.org, airlied@gmail.com,
       airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm request 3
Message-ID: <20100305180556.GA3976@elte.hu>
References: <1267748927.3496.6.camel@nisroch>
 <20100305064955.GA6453@elte.hu>
 <20100305123834.0d9c6277@lxorguk.ukuu.org.uk>
 <20100305.063718.211238119.davem@davemloft.net>
 <1267800399.6681.67.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267800399.6681.67.camel@marge.simson.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On the bright side, all this hubbub sends a very positive message to the 
> noveau development crew.  Folks, your work is important.  I'd be proud as a 
> peacock :)

Heh, most definitely so!

Noveau really is a game-changer i think, it's a big break-through for Xorg 
IMO.

For the first time in Linux history we support 90%+ of graphics hardware in a 
more or less acceptable way. That is a big deal really and the xorg/drm folks 
should be proud of that accomplishment.

It solves the nvidia.ko mess to a large degree and moves all these things into 
an actionable technical domain. I'm so much happier to argue with OSS folks 
who write this code than having to look at nvidia.ko tainted kernel crash 
logs.

	Ingo
