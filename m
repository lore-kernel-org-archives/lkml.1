Return-Path: <linux-kernel-owner+w=401wt.eu-S1751717AbXDWTDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751717AbXDWTDg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 15:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754129AbXDWTDg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 15:03:36 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35127 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751717AbXDWTDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 15:03:35 -0400
From: Russ Anderson <rja@sgi.com>
Message-Id: <200704231903.l3NJ3T1959588867@clink.americas.sgi.com>
Subject: Re: [PATCH] ia64 sn xpc: Convert to use kthread API.
To: jes@sgi.com (Jes Sorensen)
Date: Mon, 23 Apr 2007 14:03:29 -0500 (CDT)
Cc: hch@infradead.org (Christoph Hellwig),
       ebiederm@xmission.com (Eric W. Biederman),
       akpm@osdl.org (<Andrew Morton), containers@lists.osdl.org,
       oleg@tv-sign.ru (Oleg Nesterov), linux-kernel@vger.kernel.org,
       jes@sgi.com (Jes Sorensen), tony.luck@intel.com (Tony Luck),
       rja@sgi.com, holt@sgi.com, dcn@sgi.com, linux-ia64@vger.kernel.org
In-Reply-To: <462CE8D5.8040300@sgi.com> from "Jes Sorensen" at Apr 23, 2007 07:11:49 PM
X-Mailer: ELM [version 2.5 PL2]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jes Sorensen wrote:
> 
> Russ/Dean/Robin - could one of you provide some feedback to this one
> please.

Dean's on vacation for a couple days and will test it when he gets back.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
