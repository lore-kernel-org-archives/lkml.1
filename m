Return-Path: <linux-kernel-owner+w=401wt.eu-S1753073AbYE2MGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753073AbYE2MGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 08:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYE2MG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 08:06:26 -0400
Received: from lucidpixels.com ([75.144.35.66]:43701 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768AbYE2MGZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 08:06:25 -0400
Date: Thu, 29 May 2008 08:06:24 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
In-Reply-To: <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
Message-ID: <alpine.DEB.1.10.0805290805500.17643@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <Pine.LNX.4.64.0805290636020.20192@diagnostix.dwd.de>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 29 May 2008, Holger Kiehl wrote:

> On Wed, 28 May 2008, Justin Piszcz wrote:
>
>> Hardware:
>> 
>> Results:
>> 
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.html
>> http://home.comcast.net/~jpiszcz/raid/20080528/raid-levels.txt
>> 
> Why is the Sequential Output (Block) for raid6 165719 and for raid5 only
> 86797? I would have thought that raid6 was always a bit slower in writting
> due to having to write double amount of parity data.
>
> Holger
>

I will re-run the RAID5 test and also run the test on a single disk and 
update the results later.

Justin.
