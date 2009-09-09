Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZIIP7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZIIP7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 11:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753126AbZIIP7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 11:59:32 -0400
Received: from Cpsmtpm-eml109.kpnxchange.com ([195.121.3.13]:54340 "EHLO
	CPSMTPM-EML109.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753056AbZIIP7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 11:59:31 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Wed, 9 Sep 2009 17:59:30 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org
References: <200909060941.01810.elendil@planet.nl> <4AA67139.80301@lwfinger.net> <20090909150418.GI24614@csn.ul.ie>
In-Reply-To: <20090909150418.GI24614@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909091759.33655.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2009 15:59:34.0389 (UTC) FILETIME=[86591250:01CA3166]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, Mel Gorman wrote:
> Franz, in the full dmesg was there any mention of "SLUB: Unable to
> allocate memory on node"?

No, nothing at all. I double checked the kernel log, but it was completely 
quiet in the hours before and after the messages I already posted.

> Also, did you have any slub debug options enabled on the command line?

Nope.

Cheers,
FJP
