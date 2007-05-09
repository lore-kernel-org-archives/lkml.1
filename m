Return-Path: <linux-kernel-owner+w=401wt.eu-S1755971AbXEIIxt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755971AbXEIIxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:53:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754198AbXEIIxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:53:41 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:2115 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXEIIxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:53:40 -0400
Message-ID: <46418C0E.7060002@shadowen.org>
Date: Wed, 09 May 2007 09:53:34 +0100
From: Andy Whitcroft <apw@shadowen.org>
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Lee.Schermerhorn@hp.com,
       clameter@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       ak@suse.de, jbarnes@virtuousgeek.org
Subject: Re: [PATCH] change zonelist order v5 [1/3] implements zonelist order
 selection
References: <20070508201401.8f78ec37.kamezawa.hiroyu@jp.fujitsu.com>	<20070508201642.c63b3f65.kamezawa.hiroyu@jp.fujitsu.com>	<1178643985.5203.27.camel@localhost>	<Pine.LNX.4.64.0705081021340.9446@schroedinger.engr.sgi.com>	<1178645622.5203.53.camel@localhost>	<Pine.LNX.4.64.0705081104180.9941@schroedinger.engr.sgi.com>	<1178656627.5203.84.camel@localhost>	<20070509092912.3140bb78.kamezawa.hiroyu@jp.fujitsu.com>	<20070508175855.b126caf7.akpm@linux-foundation.org> <20070509131238.598e5c3d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070509131238.598e5c3d.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 0.94.2.0
OpenPGP: url=http://www.shadowen.org/~apw/public-key
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote:
> On Tue, 8 May 2007 17:58:55 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> I'm still cowering in fear of these patches, btw.
>>
>> Please keep testing and sending them ;)
>>
> I'll repost "Request-Fot-Test" version "6" against next -mm and
> add x86 as my test target at least. (I don't have other hardware.)

Copy me on the email and I'll shove the patches through TKO.

-apw
