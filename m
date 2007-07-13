Return-Path: <linux-kernel-owner+w=401wt.eu-S936065AbXGMPjv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936065AbXGMPjv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 11:39:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759520AbXGMPjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 11:39:44 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:62364 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936AbXGMPjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 11:39:43 -0400
Message-ID: <46979C4E.6000205@oracle.com>
Date: Fri, 13 Jul 2007 08:37:50 -0700
From: Herbert van den Bergh <herbert.van.den.bergh@oracle.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070613)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Dave McCracken <dave.mccracken@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] do not limit locked memory when RLIMIT_MEMLOCK is RLIM_INFINITY
References: <4692D9E0.1000308@oracle.com> <20070713004408.b7162501.akpm@linux-foundation.org>
In-Reply-To: <20070713004408.b7162501.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> 
> OK.  Seems like a nasty bug if one happens to want to do that.  Should we
> backport this into 2.6.22.x?
> 

Yes, please.  Do you need me to do anything for that?

Thanks,
Herbert.
