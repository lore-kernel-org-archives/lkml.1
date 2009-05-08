Return-Path: <linux-kernel-owner+w=401wt.eu-S1756014AbZEHIw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbZEHIw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 04:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751060AbZEHIwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 04:52:47 -0400
Received: from mga14.intel.com ([143.182.124.37]:8065 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750833AbZEHIwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 04:52:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,316,1239001200"; 
   d="scan'208";a="140622712"
Date: Fri, 8 May 2009 16:52:30 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Nigel Cunningham <nigel@tuxonice.net>,
       David Rientjes <rientjes@google.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 2/5] PM/Suspend: Do not shrink memory before
	suspend
Message-ID: <20090508085230.GA25924@localhost>
References: <200905070040.08561.rjw@sisk.pl> <200905072348.59856.rjw@sisk.pl> <200905072351.11639.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200905072351.11639.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:51:10AM +0800, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Remove the shrinking of memory from the suspend-to-RAM code, where
> it is not really necessary.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Acked-by: Nigel Cunningham <nigel@tuxonice.net>

Acked-by: Wu Fengguang <fengguang.wu@intel.com>
