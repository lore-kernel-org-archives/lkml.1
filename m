Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYBQFGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYBQFGa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 00:06:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750923AbYBQFGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 00:06:22 -0500
Received: from bebe.enoyolf.org ([24.173.215.190]:41541 "EHLO bebe.enoyolf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbYBQFGW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 00:06:22 -0500
X-Mailer: exmh enoyolf.org version 2.7.2.1 01/17/2005 with nmh-1.1
In-reply-to: <20080215193719.262c03a1.akpm@linux-foundation.org> 
References: <20080215064859.384203497@sgi.com> <20080215064932.371510599@sgi.com>  <20080215193719.262c03a1.akpm@linux-foundation.org> 
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <clameter@sgi.com>,
       Andrea Arcangeli <andrea@qumranet.com>, Robin Holt <holt@sgi.com>,
       Avi Kivity <avi@qumranet.com>, Izik Eidus <izike@qumranet.com>,
       kvm-devel@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, general@lists.openfabrics.org,
       Steve Wise <swise@opengridcomputing.com>,
       Roland Dreier <rdreier@cisco.com>, Kanoj Sarcar <kanojsarcar@yahoo.com>,
       steiner@sgi.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       daniel.blueman@quadrics.com,
       Ben Herrenschmidt <benh@kernel.crashing.org>,
       Jan-Bernd Themann <themann@de.ibm.com>
Subject: Re: [patch 1/6] mmu_notifier: Core code 
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Sat, 16 Feb 2008 23:04:50 -0600
Message-ID: <1428.1203224690@bebe.enoyolf.org>
From: Doug Maxey <dwm@enoyolf.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 15 Feb 2008 19:37:19 PST, Andrew Morton wrote:
> Which other potential clients have been identified and how important it it
> to those?

The powerpc ehea utilizes its own mmu.  Not sure about the importance 
to the driver. (But will investigate :)

++doug

