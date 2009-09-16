Return-Path: <linux-kernel-owner+w=401wt.eu-S1760115AbZIPVHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760115AbZIPVHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759965AbZIPVHD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:07:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:60707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZIPVHC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:07:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,400,1249282800"; 
   d="scan'208";a="449136355"
Message-ID: <4AB1536F.9070205@intel.com>
Date: Wed, 16 Sep 2009 14:06:55 -0700
From: "Graham, David" <david.graham@intel.com>
Reply-To: david.graham@intel.com
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [E1000-devel] [BUG 2.6.30+] e100 sometimes causes oops during
 resume
References: <20090915120538.GA26806@bizet.domek.prywatny> <13830B75AD5A2F42848F92269B11996F5BF592C3@orsmsx509.amr.corp.intel.com> <20090916014448.GA1070@bizet.domek.prywatny>
In-Reply-To: <20090916014448.GA1070@bizet.domek.prywatny>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karol Lewandowski wrote:
> 
> I can test, or rather -- start testing this tommorow, if this makes
> sense to you.
> 
Yes please Karol, test with 6905b1f1...removed. I will continue testing 
here too on 2.6.31, though I have not had a repro yet. And are you 
performing a standby or hibernate, I want to be sure that I'm resuming 
from the same state.
Thanks.
> Thanks.
> 

