Return-Path: <linux-kernel-owner+w=401wt.eu-S1760157AbZBLTo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760157AbZBLTo7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:44:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZBLTou
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:44:50 -0500
Received: from mga11.intel.com ([192.55.52.93]:20469 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbZBLTot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:44:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,198,1233561600"; 
   d="scan'208";a="665149576"
Subject: Re: [ipw3945-devel] X200: Resume and iwlwifi on
	2.6.29-rc4-ikn-00001-gd5b5623
From: reinette chatre <reinette.chatre@intel.com>
To: Nico Schottelius <nico-linux-20090209@schottelius.org>
Cc: Linux Next Mailing List <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "ipw3945-devel@lists.sourceforge.net" 
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <20090210070147.GA4684@denkbrett.schottelius.org>
References: <20090209093507.GA27678@denkbrett.schottelius.org>
	 <20090210070147.GA4684@denkbrett.schottelius.org>
Content-Type: text/plain
Date: Thu, 12 Feb 2009 11:48:40 -0800
Message-Id: <1234468120.30608.30.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-09 at 23:01 -0800, Nico Schottelius wrote:
> Good morning!
> 
> Summary on the X200:
> - First resume after suspend takes 20 seconds
> - Further resumes work fine
> - wlan works *before* first suspend and wakeup
> - after that the same happens as on 2.6.29-rc3-ikn-00697-gae1a25d:
>   the device refuses to come up with the message
>   "iwlagn: Could not load the INST uCode section" and
>   "iwlagn: Unable to set up bootstrap uCode: -110"

Sorry that I missed responding to your email in all the messages
regarding this problem. A patch was recently sent to address it - could
you please try with
http://marc.info/?l=linux-wireless&m=123429595818495&w=2 ?

Thanks

Reinette


