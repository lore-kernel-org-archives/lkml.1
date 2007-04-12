Return-Path: <linux-kernel-owner+w=401wt.eu-S1946090AbXDLJv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946090AbXDLJv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945994AbXDLJtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:49:06 -0400
Received: from rwcrmhc11.comcast.net ([204.127.192.81]:62789 "EHLO
	rwcrmhc11.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946009AbXDLJsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:48:42 -0400
Subject: Re: sched_yield proposals/rationale
From: Sven-Thorsten Dietrich <sven@thebigcorporation.com>
To: Buytaert_Steven@emc.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
References: <585DC2133F7C974F87D4EC432896F1720309F1EA@CORPUSMX10A.corp.emc.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: The Big Corporation
Date: Thu, 12 Apr 2007 02:48:39 -0700
Message-Id: <1176371319.3975.19.camel@sx.thebigcorporation.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-12 at 04:31 -0400, Buytaert_Steven@emc.com wrote:
> Since the new 2.6.x O(1) scheduler I'm having latency problems. 

1. Have you elevated the process priority?
2. Have you tried running SCHED_FIFO, or SCHED_RR?


