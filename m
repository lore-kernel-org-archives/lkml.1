Return-Path: <linux-kernel-owner+w=401wt.eu-S1762060AbZLKApt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762060AbZLKApt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 19:45:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761765AbZLKApq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 19:45:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60097 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761718AbZLKApp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 19:45:45 -0500
Date: Thu, 10 Dec 2009 16:45:21 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Dave Airlie <airlied@gmail.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Stephane Marchesin <stephane.marchesin@gmail.com>,
       Maarten Maathuis <madman2003@gmail.com>,
       Xavier Bestel <xavier.bestel@free.fr>, Dave Airlie <airlied@linux.ie>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
Subject: Re: [git pull] drm
In-Reply-To: <21d7e9970912101621q7aafbd14g8a34bedb75b6c177@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0912101633480.3560@localhost.localdomain>
References: <alpine.DEB.2.00.0912100603070.24701@skynet.skynet.ie>  <alpine.LFD.2.00.0912100716470.3560@localhost.localdomain>  <1260459601.18520.26.camel@skunk>  <alpine.LFD.2.00.0912100823220.3560@localhost.localdomain>  <6d4bc9fc0912100940l1d2954d0k187ae54bf44a23f5@mail.gmail.com>
  <alpine.LFD.2.00.0912101035140.3560@localhost.localdomain>  <6a89f9d50912101153l2b58b07fudf6965b2f5172f7f@mail.gmail.com>  <alpine.LFD.2.00.0912101531180.3560@localhost.localdomain>  <20091210235835.20e2269d@lxorguk.ukuu.org.uk> 
 <alpine.LFD.2.00.0912101601100.3560@localhost.localdomain> <21d7e9970912101621q7aafbd14g8a34bedb75b6c177@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 11 Dec 2009, Dave Airlie wrote:
> 
> I'm going to see what Ben can do with a firmware loader and the ctxprogs,
> we can send a patch that contains all the other bits of the driver, however
> since the ctxprogs aren't currently something we can add Signed-off-by to,
> someone else will have to endeavour to provide them some other way.

Hey, thanks. This was actually the first time I got the feeling that you 
acknowledged that we should strive for it to be merged at all. I literally 
feel better for just that.

			Linus
