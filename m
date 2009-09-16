Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbZIPPhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbZIPPhU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 11:37:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752965AbZIPPhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 11:37:19 -0400
Received: from cpsmtpm-eml101.kpnxchange.com ([195.121.3.5]:50073 "EHLO
	CPSMTPM-EML101.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752839AbZIPPhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 11:37:18 -0400
From: Frans Pop <elendil@planet.nl>
To: Mel Gorman <mel@csn.ul.ie>
Subject: Re: iwlagn: order 2 page allocation failures
Date: Wed, 16 Sep 2009 17:37:16 +0200
User-Agent: KMail/1.9.9
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       Andrew Morton <akpm@linux-foundation.org>, cl@linux-foundation.org,
       Assaf Krauss <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Mohamed Abbas <mohamed.abbas@intel.com>
References: <200909060941.01810.elendil@planet.nl> <200909161636.20590.elendil@planet.nl> <20090916150239.GG1993@csn.ul.ie>
In-Reply-To: <20090916150239.GG1993@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909161737.20643.elendil@planet.nl>
X-OriginalArrivalTime: 16 Sep 2009 15:37:21.0051 (UTC) FILETIME=[948216B0:01CA36E3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 September 2009, Mel Gorman wrote:
> > kcryptd: page allocation failure. order:2, mode:0x4020
> > Pid: 1347, comm: kcryptd Not tainted 2.6.31-rc9 #16
>
> Is this with Reinette Chatre's patch applied or vanilla?

Vanilla.
