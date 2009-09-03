Return-Path: <linux-kernel-owner+w=401wt.eu-S1755468AbZICN7u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbZICN7u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:59:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755455AbZICN7t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:59:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:52644 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444AbZICN7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:59:48 -0400
Subject: Re: [RFC][PATCH 08/14] sched: remove reciprocal for cpu_power
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20090903132212.822243547@chello.nl>
References: <20090903132145.482814810@chello.nl>
	 <20090903132212.822243547@chello.nl>
Content-Type: text/plain
Date: Thu, 03 Sep 2009 15:59:45 +0200
Message-Id: <1251986385.7352.2.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-03 at 15:21 +0200, Peter Zijlstra wrote:
> [andreas.herrmann3@amd.com: remove include]

/me reminds himself to quilt refresh before sending email, not after.

