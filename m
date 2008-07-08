Return-Path: <linux-kernel-owner+w=401wt.eu-S1756930AbYGHIfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbYGHIfc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 04:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751038AbYGHIfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 04:35:21 -0400
Received: from lucidpixels.com ([75.144.35.66]:52106 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbYGHIfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 04:35:20 -0400
Date: Tue, 8 Jul 2008 04:35:19 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Gerhard Wiesinger <lists@wiesinger.com>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: Lots of con-current I/O = resets SATA link? (2.6.25.10)
In-Reply-To: <alpine.LFD.1.10.0807080857460.10532@bbs.intern>
Message-ID: <alpine.DEB.1.10.0807080434470.17980@p34.internal.lan>
References: <alpine.DEB.1.10.0807051252200.12562@p34.internal.lan> <alpine.LFD.1.10.0807071649340.1160@bbs.intern> <alpine.LFD.1.10.0807071705490.2997@bbs.intern> <alpine.DEB.1.10.0807071149530.32508@p34.internal.lan> <alpine.LFD.1.10.0807080811560.5439@bbs.intern>
 <alpine.LFD.1.10.0807080857460.10532@bbs.intern>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2008, Gerhard Wiesinger wrote:

> Hello!
>
> BTW:
> The error in syslog also accoured when Reallocated_Sector_Ct didn't go up.
>

Yes, I have seen the same thing on drives going bad as well.

What type of PSU are you using (per the other thread) and how are you 
splitting the power connectors/etc?

Justin.

