Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbZIPQ0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbZIPQ0q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 12:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbZIPQ0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 12:26:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:55993 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662AbZIPQ0k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 12:26:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,398,1249282800"; 
   d="scan'208";a="494064605"
Subject: Re: iwlagn: order 2 page allocation failures
From: reinette chatre <reinette.chatre@intel.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Frans Pop <elendil@planet.nl>, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "cl@linux-foundation.org" <cl@linux-foundation.org>,
       "Krauss, Assaf" <assaf.krauss@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "Abbas, Mohamed" <mohamed.abbas@intel.com>
In-Reply-To: <20090916150239.GG1993@csn.ul.ie>
References: <200909060941.01810.elendil@planet.nl>
	 <20090909165545.GK24614@csn.ul.ie> <200909091919.16461.elendil@planet.nl>
	 <200909161636.20590.elendil@planet.nl>  <20090916150239.GG1993@csn.ul.ie>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 09:26:43 -0700
Message-Id: <1253118403.26521.418.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-16 at 08:02 -0700, Mel Gorman wrote:
> If vanilla, Reinette, is your patch already upstream or in a subsystem
> tree somewhere?

Not yet. 

Reinette


