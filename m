Return-Path: <linux-kernel-owner+w=401wt.eu-S1754703AbXIHQsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703AbXIHQsu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2007 12:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbXIHQsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Sep 2007 12:48:38 -0400
Received: from lucidpixels.com ([75.144.35.66]:44247 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753508AbXIHQsh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2007 12:48:37 -0400
Date: Sat, 8 Sep 2007 12:48:36 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: linux-kernel@vger.kernel.org
cc: linux-net@vger.kernel.org, linux-raid@vger.kernel.org,
       apiszcz@solarrain.com
Subject: AoE/2.6 Question (CORAID brand)
Message-ID: <Pine.LNX.4.64.0709081246310.22467@p34.internal.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The reason for the 10Gbps question was in most of the benchmarks I see 
10Gbps achieves roughly 250 MiB/s as others have reported on other mailing 
lists.

This company makes AoE / RAIDs (24 disks) quite cheap and they offer 
10Gbps on their units, has anyone done any independent benchmarking of 
their units?

They claim 550 MiB/s on them.

What type of RAID do they use for AoE?  Is it Linux SW Raid embedded in 
the unit?

http://www.coraid.com/

What type of speeds are typical on 1Gbps vs. 10Gbps AoE connections?

Justin.
