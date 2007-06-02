Return-Path: <linux-kernel-owner+w=401wt.eu-S1763977AbXFBWzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763977AbXFBWzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 18:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762470AbXFBWzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 18:55:46 -0400
Received: from lucidpixels.com ([75.144.35.66]:53036 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761812AbXFBWzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 18:55:46 -0400
Date: Sat, 2 Jun 2007 18:55:45 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <4661F511.4070207@goop.org>
Message-ID: <Pine.LNX.4.64.0706021855260.3376@p34.internal.lan>
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
 <4661F511.4070207@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 2 Jun 2007, Jeremy Fitzhardinge wrote:

> Justin Piszcz wrote:
>> Wondering as their were a lot of XFS related issues early on in
>> development..? The 2.6.22-rc3 kernel has the core 2 duo coretemp patch
>> by ruik which I want be running as long as 2.6.22-rc3 does not have
>> any severe XFS issues?
>
> XFS currently has a data-corrupting bug, where files which were appended
> by small amounts may lose their updates on umount - I see this
> corrupting hg repos. There's a patch which works for me, and is in
> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.
>
> J
>
>

Ah that's it- and USB appears to be broken as well, I'll stick with 
2.6.21.3 for now.

Thanks!

Justin.

