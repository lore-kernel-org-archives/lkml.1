Return-Path: <linux-kernel-owner+w=401wt.eu-S1030892AbXAZRRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030892AbXAZRRA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:17:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030891AbXAZRRA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:17:00 -0500
Received: from omx2-ext.sgi.com ([192.48.171.19]:38902 "EHLO omx2.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030892AbXAZRQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:16:59 -0500
Date: Fri, 26 Jan 2007 09:16:50 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Mel Gorman <mel@csn.ul.ie>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] Create the ZONE_MOVABLE zone
In-Reply-To: <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
Message-ID: <Pine.LNX.4.64.0701260915390.7209@schroedinger.engr.sgi.com>
References: <20070125234458.28809.5412.sendpatchset@skynet.skynet.ie>
 <20070125234538.28809.24662.sendpatchset@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I do not see any updates of vmstat.c and vmstat.h. This 
means that VM statistics are not kept / considered for ZONE_MOVABLE.

