Return-Path: <linux-kernel-owner+w=401wt.eu-S1754975AbZGGHSf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975AbZGGHSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 03:18:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbZGGHS2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 03:18:28 -0400
Received: from mga03.intel.com ([143.182.124.21]:18110 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbZGGHS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 03:18:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,361,1243839600"; 
   d="scan'208";a="162209174"
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage
 unusable on non-NUMA machine
From: Alex Shi <alex.shi@intel.com>
Reply-To: alex.shi@intel.com
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
In-Reply-To: <4A5291C5.5090605@kernel.org>
References: <bug-13690-10286@http.bugzilla.kernel.org/>
	 <20090701183452.8660c8a9.akpm@linux-foundation.org>
	 <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp>
	 <4A4C74D8.30809@kernel.org>
	 <1246850004.18539.87.camel@alexs-hp.sh.intel.com>
	 <4A5291C5.5090605@kernel.org>
Content-Type: text/plain
Organization: intel.com
Date: Tue, 07 Jul 2009 15:23:06 +0800
Message-Id: <1246951386.25812.4.camel@alexs-hp.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-07-07 at 08:07 +0800, Yinghai Lu wrote:
> Alex Shi wrote:
> > Yinghai:
> > 
> > The 31-rc2 kernel still can not use hugepage on non-NUMA machine. And
> > this patch did not appear on rc2 kernel. Are there some concern about
> > this? 
> > 
> 
> can you check
> http://lkml.org/lkml/2009/7/2/326
> 
> YH

It works on my Stoakley i386 and x86_64 with latest Linus' kernel tree. 



Alex 

