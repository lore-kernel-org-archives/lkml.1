Return-Path: <linux-kernel-owner+w=401wt.eu-S1754213AbYAIGJe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213AbYAIGJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 01:09:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751558AbYAIGJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 01:09:24 -0500
Received: from rtr.ca ([76.10.145.34]:1837 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751555AbYAIGJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 01:09:23 -0500
Message-ID: <47846511.30805@rtr.ca>
Date: Wed, 09 Jan 2008 01:09:21 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Tejun Heo <htejun@gmail.com>
Cc: Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Mark Lord <liml@rtr.ca>
Subject: Re: Do SATA tape drives work?
References: <200801090329.m093T7Op019488@turbo.physics.adelaide.edu.au> <4784591D.3060000@gmail.com>
In-Reply-To: <4784591D.3060000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> [cc'ing linux-ide]
> 
> Jonathan Woithe wrote:
>> Hi guys
>>
>> I was wondering whether anyone can shed any light on the status of SATA tape
>> drives.  There's very little info on the net about this at least in the
>> places I've checked; the only thing of any significance I've found thus far
>> is a note in a Bacula document dated April 2007 which states that drives
>> other than real SCSI units don't generally work with Bacula.
>>
>> To put this into context, I'm looking at purchasing a Sony SDX470VRB SATA
>> AIT-1 tape drive for use with the SATA controller on an Intel DG31PR
>> mainboard.  The drive will be used primarily with tar/cpio.  Obvsiouly
>> however I only want to make the purchase if there's a reasonable chance of
>> it working.
>>
>> I would appreciate any information you can shed on this issue.
> 
> It's supposed to with recent updates.  Mark, right?
..

I wouldn't buy anything with "Sony" on it,
but Albert thinks ATAPI tapes should be working now
(he has my old drive now).
 

