Return-Path: <linux-kernel-owner+w=401wt.eu-S933224AbXDFWnb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224AbXDFWnb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 18:43:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933274AbXDFWnb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 18:43:31 -0400
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:31931 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S933224AbXDFWna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 18:43:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uu+g5+WxkHBY4cmjGSkfIGnlf/29fveGomErvu95MGAHhf+uRKw4LYC3RWpuRlANqnTfr+XK/Rsh3zQnvzjwbTqJ+IXpWa9sCxDgLWGaOGAk4mL3pgP05078HEwaQvK0gh4u/F1+1E5U0BvwY8GGHCeXQ1QH3QZqQgPXJXvSPk4=  ;
X-YMail-OSG: 1aSaD0IVM1lIqqb25s3kxzHdnwGbyW_17fRrrA8Q6jgiL9usvTsxJqJdn3_0C9LNmjeDQ9dkW1Ia1MVlL013IerLv1Lqqzpqcv8W
From: David Brownell <david-b@pacbell.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: coding style for long conditions
Date: Fri, 6 Apr 2007 15:43:28 -0700
User-Agent: KMail/1.7.1
Cc: Roland Dreier <rdreier@cisco.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
References: <11757099691323-git-send-email-tony@atomide.com> <200704061505.41956.david-b@pacbell.net> <Pine.LNX.4.61.0704070007140.6042@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0704070007140.6042@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704061543.28746.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 April 2007 3:07 pm, Jan Engelhardt wrote:
> 
> On Apr 6 2007 15:05, David Brownell wrote:
> >
> >> but... egads!  Linus 
> >> put spaces before the &&s to line them up nicely!
> >> 
> >> "more in the breach" and all that I guess...
> >
> >Yeah, nobody likes style nazis.  On the other hand, it's rather
> >unusual to be the target of style nazism for actually following
> >the style guide!!  You'd think that maybe the folk objecting to
> >that style guide might maybe choose a more direct way to address
> >their particular frustrations, eh?  :)
> 
> About time...
> http://en.wikipedia.org/wiki/Godwin%27s_Law

With respect to coding style discussions, "style nazi" happens to be
what's called a "term of art".  

But if your invocation of Godwin's law helps stop this, I'll be glad.

