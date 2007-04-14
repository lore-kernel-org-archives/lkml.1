Return-Path: <linux-kernel-owner+w=401wt.eu-S965440AbXDNSpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965440AbXDNSpz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXDNSpz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:45:55 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:7838 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965440AbXDNSpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:45:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=DRkfFKke3HtvSih4ntWkemf/SaLGV3206VdL/BAKukm/ApflwehVfWK2G/Ifoj2REAP7T22EMpRJL/AxB28cgeYHgohax42N1Kgivfr1IifN38F4D443Y7aO/a5en7JPtDH+TBt1LxdToB4RZPQx5GBkaz5VdWagvy8wL5ou0cg=
Message-ID: <75b57c110704141145r2b371d5dpbcf915973b83789a@mail.gmail.com>
Date: Sat, 14 Apr 2007 14:45:53 -0400
From: "Gerb Stralko" <gerb.stralko@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: GIT and the current -stable
Cc: "Junio C Hamano" <junkio@cox.net>, "Rene Herman" <rene.herman@gmail.com>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Greg KH" <greg@kroah.com>, git@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704141028460.5473@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46206842.80203@gmail.com>
	 <7vfy73bhik.fsf@assigned-by-dhcp.cox.net>
	 <Pine.LNX.4.64.0704141028460.5473@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Please don't do this. Using the same name for a branch as for a tag is
> madness. Call it "v2.6.20-stable" or anything else, but don't re-use the
> same naming as for tags.
>

Yes I have done this before, and it took me awhile to realize what was
going on.  It caused me some grief, and a few hours of lost time...Of
course this was back in my earlier days ;)
