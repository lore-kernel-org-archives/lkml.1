Return-Path: <linux-kernel-owner+w=401wt.eu-S1759449AbZGGAVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759449AbZGGAVd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 20:21:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756476AbZGGAKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 20:10:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:35842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbZGGAKU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 20:10:20 -0400
Message-ID: <4A5291C5.5090605@kernel.org>
Date: Mon, 06 Jul 2009 17:07:33 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: alex.shi@intel.com
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "bugzilla-daemon@bugzilla.kernel.org" 
	<bugzilla-daemon@bugzilla.kernel.org>,
       "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Zhang, Yanmin" <yanmin.zhang@intel.com>,
       "Chen, Tim C" <tim.c.chen@intel.com>
Subject: Re: [Bugme-new] [Bug 13690] New: nodes_clear cause hugepage unusable
 on non-NUMA machine
References: <bug-13690-10286@http.bugzilla.kernel.org/>	 <20090701183452.8660c8a9.akpm@linux-foundation.org>	 <4A4C17FD.3080404@kernel.org> <1246517111.15721.5.camel@alexs-hp>	 <4A4C74D8.30809@kernel.org> <1246850004.18539.87.camel@alexs-hp.sh.intel.com>
In-Reply-To: <1246850004.18539.87.camel@alexs-hp.sh.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi wrote:
> Yinghai:
> 
> The 31-rc2 kernel still can not use hugepage on non-NUMA machine. And
> this patch did not appear on rc2 kernel. Are there some concern about
> this? 
> 

can you check
http://lkml.org/lkml/2009/7/2/326

YH
