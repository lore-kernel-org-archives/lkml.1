Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1753022AbYLQXVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753022AbYLQXVj (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 18:21:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYLQXVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 18:21:24 -0500
Received: from lucidpixels.com ([75.144.35.66]:38026 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752214AbYLQXVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 18:21:23 -0500
Date: Wed, 17 Dec 2008 18:21:22 -0500 (EST)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Bill Davidsen <davidsen@tmr.com>
cc: Redeeman <redeeman@metanurb.dk>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, xfs@oss.sgi.com,
        smartmontools-support@lists.sourceforge.net
Subject: Re: Have the velociraptors in a test system now, checkout the
 errors.
In-Reply-To: <4949645F.4030407@tmr.com>
Message-ID: <alpine.DEB.1.10.0812171820200.26527@p34.internal.lan>
References: <alpine.DEB.1.10.0812060426280.3494@p34.internal.lan>  <49405A94.8080601@tmr.com> <1229225303.16555.149.camel@localhost> <4949645F.4030407@tmr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 17 Dec 2008, Bill Davidsen wrote:

> Redeeman wrote:
>> On Wed, 2008-12-10 at 19:11 -0500, Bill Davidsen wrote:
>> 
>>> Justin Piszcz wrote:
>>> 
>
> Calls itself "WDC WD10EACS-00D" in /sys if that helps. I could dig out the 
> packing slip if it matters. Runs nicely so far, and if the SMART temperature 
> probe is correct, very cool:
>
> /dev/sda: ST3750640AS: 43 C
> /dev/sdb: WDC WD10EACS-00D6B1: 31 C
> /dev/sdc: ST3750640AS: 44 C
> /dev/sdd: ST3750640AS: 46 C
>
> I don't totally trust the temps, there is a LOT of 18C air going into that 
> box, because it has a lot coming out the back and side.

Hmm do you have a picture of those seagates? Seems like a lack of airflow there
or do they just run really hot?  Also, how many head unload/loads has the
1.0TB GP drive performed, that was one of my concerns when I was looking at
disks.

Justin.

