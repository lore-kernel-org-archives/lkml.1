Return-Path: <linux-kernel-owner+w=401wt.eu-S933727AbXBZAiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933727AbXBZAiN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 19:38:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933728AbXBZAiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 19:38:13 -0500
Received: from stargate.chelsio.com ([12.22.49.110]:18145 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbXBZAiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 19:38:12 -0500
Message-ID: <45E22B91.1060702@chelsio.com>
Date: Sun, 25 Feb 2007 16:36:33 -0800
From: Divy Le Ray <divy@chelsio.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Steve Wise <swise@opengridcomputing.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] cxgb3 - FW version update
References: <20070225004401.20831.3292.stgit@localhost.localdomain>	 <1172431719.4717.8.camel@stevo-laptop>  <45E1E810.2000706@garzik.org> <1172440758.4717.17.camel@stevo-laptop> <45E21009.6040706@garzik.org>
In-Reply-To: <45E21009.6040706@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Feb 2007 00:36:35.0898 (UTC) FILETIME=[2BAD71A0:01C7593E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Steve Wise wrote:
>>> I would rather fix the code to use constants, and thus avoid this 
>>> problem ever happening again.
>>>
>>>     Jeff
>>>
>>
>> How's this (not tested)?
>
> seems OK to me
>
>
I tested it and resubmitted. Thanks fro the fix suggestion and the patch!

Cheers,
Divy
