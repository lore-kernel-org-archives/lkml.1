Return-Path: <linux-kernel-owner+w=401wt.eu-S935317AbXFFUh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317AbXFFUh1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933796AbXFFUhS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:37:18 -0400
Received: from lucidpixels.com ([75.144.35.66]:43141 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbXFFUhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:37:17 -0400
Date: Wed, 6 Jun 2007 16:37:15 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jesse Barnes <jesse.barnes@intel.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] trim memory not covered by WB MTRRs
In-Reply-To: <200706061331.30516.jesse.barnes@intel.com>
Message-ID: <Pine.LNX.4.64.0706061636550.21038@p34.internal.lan>
References: <200706061229.24486.jesse.barnes@intel.com>
 <Pine.LNX.4.64.0706061626360.21038@p34.internal.lan>
 <200706061328.53443.jesse.barnes@intel.com> <200706061331.30516.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 6 Jun 2007, Jesse Barnes wrote:

> On Wednesday, June 6, 2007 1:28 pm Jesse Barnes wrote:
>>> Against what kernel version does this patch apply?
>>
>> Um... git as of b4946ffb1860597b187d78d61ac6504177eb0ff8.  Sorry I
>> should have updated before spinning the patch (will do now).
>
> Appears to apply cleanly to git head as of a minute ago too.
>
> Jesse
>

Can you produce a patch against 2.6.22-rc4 or 2.6.21 so I and other people 
can easily try it? I do not have git installed on this machine, thanks.

Justin.
