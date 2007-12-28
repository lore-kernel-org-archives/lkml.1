Return-Path: <linux-kernel-owner+w=401wt.eu-S1754815AbXL1PbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815AbXL1PbD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 10:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754035AbXL1Pav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 10:30:51 -0500
Received: from stinky.trash.net ([213.144.137.162]:32839 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668AbXL1Pau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 10:30:50 -0500
Message-ID: <4775169C.8040302@trash.net>
Date: Fri, 28 Dec 2007 16:30:36 +0100
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.6 (X11/20071009)
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Harald Welte <laforge@gnumonks.org>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Netfilter Development Mailinglist 
	<netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] net/ipv4/netfilter/ip_tables.c: remove some inlines
References: <200712161247.53986.vda.linux@googlemail.com> <47668BE9.8010504@trash.net> <200712270401.35983.vda.linux@googlemail.com>
In-Reply-To: <200712270401.35983.vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko wrote:
> On Monday 17 December 2007 14:47, Patrick McHardy wrote:
>   
>> This clashes with my pending patches, which I'll push upstream
>> today. I also spent some time resyncing ip_tables and ip6_tables
>> so a diff of both (with some sed'ing) shows only the actual
>> differences, so please update ip6_tables as well.
>>     
>
> I would be happy to rediff the patch.
>
> Which tree should I sync against in order to not collide
> with your changes?
>   

The net-2.6.25.git tree contains all my changes.
