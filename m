Return-Path: <linux-kernel-owner+w=401wt.eu-S932966AbXB1Oz5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932966AbXB1Oz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 09:55:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932968AbXB1Oz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 09:55:57 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:49682 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932966AbXB1Oz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 09:55:57 -0500
In-Reply-To: <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net>
References: <45E46976.6060600@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D6E8@dmoexc01.emea.cpqcorp.net> <45E57CE5.5010003@zytor.com> <93C4769E3BED6B42B7203BD6F065654C08C5D7FF@dmoexc01.emea.cpqcorp.net> <45E593C2.6020004@freescale.com> <93C4769E3BED6B42B7203BD6F065654C08C5D8FD@dmoexc01.emea.cpqcorp.net>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <0DA3FFD2-CFB8-44FB-872B-00D85B11213B@kernel.crashing.org>
Cc: "Timur Tabi" <timur@freescale.com>, "H. Peter Anvin" <hpa@zytor.com>,
       <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: lanana: Add major/minor entries for PPC QE UART devices
Date: Wed, 28 Feb 2007 08:54:58 -0600
To: "Mathiasen, Torben" <Torben.Mathiasen@hp.com>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 28, 2007, at 8:51 AM, Mathiasen, Torben wrote:

>>
>> Mathiasen, Torben wrote:
>>
>>> Assuming QE has 4 entries, I would expect CPM to be the same. But we
>>> need verification of that. If it needs 6, we are in more trouble.
>>
>> The QE can have up to 8, actually, but I'm willing to limit the  
>> driver
>> to 4.
>
> Its your choice if you want to limit it to 4 or have it moved into a
> different minor range. I can live with both.

I'd rather we support 8 now.

- k
