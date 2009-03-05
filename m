Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbZCEHFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbZCEHFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 02:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752282AbZCEHFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 02:05:17 -0500
Received: from stinky.trash.net ([213.144.137.162]:59407 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbZCEHFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 02:05:16 -0500
Message-ID: <49AF79A6.6030002@trash.net>
Date: Thu, 05 Mar 2009 08:05:10 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: bart@jukie.net, greearb@candelatech.com, shemminger@vyatta.com,
       dada1@cosmosbay.com, frank.blaschka@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [BUG] 2.6.29-rc* QinQ vlan trunking regression
References: <20090304.195328.106253933.davem@davemloft.net>	<49AF685D.90907@trash.net>	<20090304.225719.159854470.davem@davemloft.net> <20090304.230023.09984572.davem@davemloft.net>
In-Reply-To: <20090304.230023.09984572.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> I think this will fix it.

Good catch, that looks like a likely cause. Will test in a minute ...
