Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbZC3M2E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbZC3M2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 08:28:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757273AbZC3M1l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 08:27:41 -0400
Received: from tassadar.physics.auth.gr ([155.207.123.25]:45103 "EHLO
	tassadar.physics.auth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758242AbZC3M1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 08:27:40 -0400
Date: Mon, 30 Mar 2009 15:27:15 +0300 (EEST)
From: Dimitris Zilaskos <dzila@tassadar.physics.auth.gr>
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: peak vnodes <number>
In-Reply-To: <87skkvmc69.fsf@basil.nowhere.org>
Message-ID: <Pine.LNX.4.64.0903301526050.3038@tassadar.physics.auth.gr>
References: <Pine.LNX.4.64.0903300259500.27035@tassadar.physics.auth.gr>
 <87skkvmc69.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Mar 2009, Andi Kleen wrote:

> Dimitris Zilaskos <dzila@tassadar.physics.auth.gr> writes:
>
>> After moving to 2.6.29 the following started showing up in kernel
>> logs. What does it mean?
>>
>>
>> uname -an
>> Linux tassadar 2.6.29 #1 Sat Mar 28 22:52:51 EET 2009 i686 unknown
>> unknown GNU/Linux
>>
>>
>> dmesg|grep peak|head
>> peak vnodes: 4164
>
> Grepping doesn't find such a message in 2.6.29. Are you sure it's not
> some out of tree module?
>
> -Andi


Thank you for your answer. I use openafs, so I guess it could be their 
module. I will foward my question there.


Cheers,

-- 
=============================================================================
Dimitris Zilaskos
GridAUTH Operations Centre @ Aristotle University of Thessaloniki , Greece
Tel: +302310998988 Fax: +302310994309
http://www.grid.auth.gr 
=============================================================================
