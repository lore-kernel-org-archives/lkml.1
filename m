Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbXEJJox@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbXEJJox (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 05:44:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755589AbXEJJor
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 05:44:47 -0400
Received: from an-out-0708.google.com ([209.85.132.248]:35845 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753643AbXEJJoq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 05:44:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qS6ELFRHBcAEmeHS5iEUqlwKdY8H0/9DN5rLthmgBA2xDhvTfe+UNMn98L4yyvxorlbeZaDqFKD4DF41mQqqK/VkryrtDHIDd8yIsH0/qqmxjeKh6gfI1Z+TtxK9GZHpEn1pogPHq1azcDw5sLpBgPRnVDApyN9T3BfD5GU5YVg=
Message-ID: <9a8748490705100244v58cc6ac5x1d575d177f6f62a1@mail.gmail.com>
Date: Thu, 10 May 2007 11:44:45 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Adrian Bunk" <bunk@stusta.de>
Subject: Re: remove broken URLs from net drivers' output
Cc: "Jeff Garzik" <jeff@garzik.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Markus Dahms" <dahms@fh-brandenburg.de>
In-Reply-To: <20070510044759.GG23574@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200705092102.l49L2Re6028694@hera.kernel.org>
	 <46424E12.9070307@garzik.org>
	 <9a8748490705091604l32b0e6depbc079f69897b34e0@mail.gmail.com>
	 <20070510040739.GF23574@stusta.de> <46429E23.6050404@garzik.org>
	 <20070510044759.GG23574@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/07, Adrian Bunk <bunk@stusta.de> wrote:
> On Thu, May 10, 2007 at 12:22:59AM -0400, Jeff Garzik wrote:
> > Adrian Bunk wrote:
> >> I thought it was just an informal tag to mark which people did agree with
> >> the patch (and the line between your "Makes good sense to me." and a "Feel
> >> free to add my ACK to this" is really thin).
> >
> > No, the line is easy and obvious:  if there is any doubt, DO NOT ASSUME.
> >
> > If they do not explicitly ACK it, then do not presume to speak for them.
>
> There is no doubt that Jesper did explicitly ACK the patch.
> We are ONLY discussing whether his informal ACK can be translated into
> an "Acked-by:" line.
>
Right. The patch is fine. What I said when I commented on it was an
ACK, that's not being debated.
I just thought that Acked-by: was considered a lot more formal and was
surprised to see that line with my name on the patch. But I've since
checked up on that assumption and I can't find anything that states
that it is considered as formal as I thought it was, so the mistake is
all mine and what you did is fine.

If Acked-by: should be made more formal or not is a different discussion.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
