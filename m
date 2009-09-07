Return-Path: <linux-kernel-owner+w=401wt.eu-S1751709AbZIGMhG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751709AbZIGMhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 08:37:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbZIGMhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 08:37:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:53951 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbZIGMhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 08:37:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4AA4FE4E.7000402@s5r6.in-berlin.de>
Date: Mon, 07 Sep 2009 14:36:30 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Frans Pop <elendil@planet.nl>, kernel@kolivas.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [quad core results] BFS vs. mainline scheduler benchmarks and
 measurements
References: <20090906205952.GA6516@elte.hu> <200909070405.23936.elendil@planet.nl> <20090907121613.GA32097@elte.hu>
In-Reply-To: <20090907121613.GA32097@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'd really encourage everyone to test these things yourself 
> as well and not take anyone's word on this as granted. The more 
> people provide numbers, the better.

Besides mean values from bandwidth and latency focused tests, standard 
deviations or variance, or e.g. 90th percentiles and perhaps maxima of 
latency focused tests might be of interest.  Or graphs with error bars.
-- 
Stefan Richter
-=====-==--= =--= --===
http://arcgraph.de/sr/
