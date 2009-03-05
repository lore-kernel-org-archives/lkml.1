Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbZCEH0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbZCEH0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:26:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZCEH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:26:17 -0500
Received: from stinky.trash.net ([213.144.137.162]:59790 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753421AbZCEH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:26:16 -0500
Message-ID: <49AF7E93.2010800@trash.net>
Date: Thu, 05 Mar 2009 08:26:11 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: bart@jukie.net, greearb@candelatech.com, shemminger@vyatta.com,
       dada1@cosmosbay.com, frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <49AF79A6.6030002@trash.net>	<20090304.231120.86999183.davem@davemloft.net>	<49AF7B72.2020905@trash.net> <20090304.231911.213286076.davem@davemloft.net>
In-Reply-To: <20090304.231911.213286076.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Thu, 05 Mar 2009 08:12:50 +0100
> 
>>> We probably need both fixes to cover everything.
>>>
>> Yes, just the second one still crashes. I'm about to retry using both.
> 
> Here is the updated version just for the record:
> 
> vlan: Fix vlan-in-vlan crashes.

This still crashes. I'll have another look at the code.
