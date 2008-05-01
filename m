Return-Path: <linux-kernel-owner+w=401wt.eu-S1760022AbYEAMuk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760022AbYEAMuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 08:50:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754116AbYEAMu3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 08:50:29 -0400
Received: from lucidpixels.com ([75.144.35.66]:40734 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbYEAMu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 08:50:28 -0400
Date: Thu, 1 May 2008 08:50:27 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alex Davis <alex14641@yahoo.com>
cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Sharing disks amoung multiple software RAIDs
In-Reply-To: <771640.4981.qm@web50209.mail.re2.yahoo.com>
Message-ID: <alpine.DEB.1.10.0805010849380.20043@p34.internal.lan>
References: <771640.4981.qm@web50209.mail.re2.yahoo.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Alex Davis wrote:

> Is this a bad thing? I'm guessing that it is, but I want independent
> confirmation before I spoke to someone I know who's doing this.
>
> Thanks
>
>
>      ____________________________________________________________________________________
> Be a better friend, newshound, and
> know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

What is the use case, why would you want to do that?
I have seen people on the list do it before, for example are you going to 
be utilizing both raids at the same time?  If so, I would advise against 
it.

What is the reasoning?

