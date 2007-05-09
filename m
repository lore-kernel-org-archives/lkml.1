Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbXEIIva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbXEIIva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 04:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXEIIvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 04:51:21 -0400
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:32855 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754003AbXEIIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 04:51:20 -0400
Message-ID: <46418B4D.6030307@s5r6.in-berlin.de>
Date: Wed, 09 May 2007 10:50:21 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.2) Gecko/20070222 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: Satyam Sharma <satyam.sharma@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Sokolovsky <pmiscml@gmail.com>, linux-kernel@vger.kernel.org,
       rientjes@google.com, jeremy@goop.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: volatile considered evil
References: <516386418.20070501080839@gmail.com>	<20070430235642.e576e917.akpm@linux-foundation.org>	<20070508121404.17bd97a6.randy.dunlap@oracle.com>	<a781481a0705081307r546f8889qecca3db16ea03fb8@mail.gmail.com> <20070508163452.8b71f682.randy.dunlap@oracle.com>
In-Reply-To: <20070508163452.8b71f682.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> Add information on the problems with the C-language "volatile" keyword
> and why it should not be used (most of the time).

I like Jonathan's article http://lwn.net/Articles/233479/ a lot.
It puts as much emphasis on the DOs as on the DON'Ts, which I find helpful.
-- 
Stefan Richter
-=====-=-=== -=-= -=--=
http://arcgraph.de/sr/
