Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab0CERDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 12:03:31 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:44324 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753880Ab0CERDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 12:03:30 -0500
Date: Fri, 5 Mar 2010 17:04:14 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, daniel@fooishbar.org,
       skeggsb@gmail.com, airlied@linux.ie, linux-kernel@vger.kernel.org,
       jbarnes@virtuousgeek.org, dri-devel@lists.sf.net, mingo@elte.hu
Subject: Re: [git pull] drm request 3
Message-ID: <20100305170414.46acfb8f@lxorguk.ukuu.org.uk>
In-Reply-To: <alpine.LFD.2.00.1003050832250.3788@localhost.localdomain>
References: <20100305151754.GB2505@tempa>
	<20100305.072612.186421758.davem@davemloft.net>
	<20100305154009.GC2505@tempa>
	<20100305.074835.159078083.davem@davemloft.net>
	<20100305160217.663413eb@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003050810140.3788@localhost.localdomain>
	<20100305162327.084d4038@lxorguk.ukuu.org.uk>
	<alpine.LFD.2.00.1003050832250.3788@localhost.localdomain>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Look at who I screamed at. Dave Airlie. The guy who works for Red Hat. The 
> guy who is, as far as I know, effectively in charge of that whole 
> integration. Yeah, I realize that there are other people (Kyle?) involved, 
> and maybe Dave isn't as central as I think he is, but I learnt from last 
> time that the nouveau guys don't seem to care.

Ok "screamed about" is perhaps better wording. Why should the Nouveau
guys care ? You've forced their hand, you've demanded stuff they
said they didn't want to do and then you've bitched about things they
said they would do. Actually I think they've been quite restrained. I'd
probably have proposed a licence change to make it only work on FreeBSD
and Solaris given that treatment ;)

> Even if you need to change the interface, I've actually looked at the 
> patch in question (have you, Alan?),

Yes but I read it somewhat differently.

Someone who never made a commitment to stability decided to do the
logical thing. They deleted all the old broken interfaces, they cleaned
up their ioctls numbering and they tided up afterwards. I read it as the
action of someone who simply doesnt acknowledge that you have a right to
control their development and is continuing to work in the way they
intended.

You can only see it as malicious if you assume they ever had some reason
to keep compatibility or had promised it somewhere. Quite the reverse
happened, and they never asked to be upstream in the first place.


	"But the fact is, at least from my standpoint, I'd really
	hope that anything I had written would be used in ways I asked
	people to"
				- Linus Torvalds, 2004



