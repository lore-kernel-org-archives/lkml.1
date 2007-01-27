Return-Path: <linux-kernel-owner+w=401wt.eu-S1752341AbXA0S7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341AbXA0S7v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 13:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbXA0S7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 13:59:48 -0500
Received: from terminus.zytor.com ([192.83.249.54]:38224 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340AbXA0S7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 13:59:47 -0500
Message-ID: <45BBA11A.3050407@zytor.com>
Date: Sat, 27 Jan 2007 10:59:38 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: Git Mailing List <git@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: git.kernel.org move (finally)... estimated week of Feb 5
References: <45BAA82B.6000105@zytor.com> <625fc13d0701270846n710e833cnb1926e9fd51d8b59@mail.gmail.com>
In-Reply-To: <625fc13d0701270846n710e833cnb1926e9fd51d8b59@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Boyer wrote:
> On 1/26/07, H. Peter Anvin <hpa@zytor.com> wrote:
>> Just for everyone's information...
>>
>> The git performance issues (especially) on kernel.org has been very
>> frustrating, obviously.  We're putting a dedicated git server in place
>> hopefully the week of February 5.
> 
> For the hardware geeks out there, do you know what kind of machine it 
> will be?
> 

Sure... it's the DL380 G2 that used to be zeus.kernel.org.  It's not 
ideal (in particular, I would have preferred a 64-bit machine), but it 
has the advantage that it's proven itself rock-solid over the years, it 
has all the hands-off management features, we have it, and it has 6 GB RAM.

As far as filesystem is concerned, we might decide to use this machine 
to test out XFS.  Haven't made the formal decision yet.

	-hpa
