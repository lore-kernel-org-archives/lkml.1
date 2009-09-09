Return-Path: <linux-kernel-owner+w=401wt.eu-S1753499AbZIIRTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499AbZIIRTP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 13:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752373AbZIIRTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 13:19:14 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:63038 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752012AbZIIRTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 13:19:14 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Wed, 9 Sep 2009 19:19:12 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
References: <200909060941.01810.elendil@planet.nl> <200909091759.33655.elendil@planet.nl> <20090909165545.GK24614@csn.ul.ie>
In-Reply-To: <20090909165545.GK24614@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909091919.16461.elendil@planet.nl>
X-OriginalArrivalTime: 09 Sep 2009 17:19:17.0032 (UTC) FILETIME=[A9067A80:01CA3171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 September 2009, you wrote:
> The problem with this theory is that the patches have been in since Nov
> 2008 but reports are only showing up now.  Frans, how sure are you that
> this is a recent problem? Is it readily reproducible?

The only thing I can say here is that I've never seen the issue before 
(and thanks to logcheck I certainly would have).
The laptop is in constant use, but I rarely stress the memory like that. 
Swap is almost always at 0.

I would have to make an effort to try and reproduce it, probably by again 
creating some very large images and loading those in konqueror, maybe 
while streaming a movie over wireless or something.

Thanks for your efforts,
FJP
