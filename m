Return-Path: <linux-kernel-owner+w=401wt.eu-S1764654AbZFQX2t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764654AbZFQX2t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 19:28:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbZFQX17
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 19:27:59 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:50216 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764279AbZFQX16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 19:27:58 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19001.31734.428534.890844@cargo.ozlabs.ibm.com>
Date: Thu, 18 Jun 2009 09:27:50 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: benh@kernel.crashing.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/6] perf_counter: powerpc: Enable use of software
	counters on 32-bit powerpc
In-Reply-To: <20090617142151.GB6846@elte.hu>
References: <19000.55404.103840.393470@cargo.ozlabs.ibm.com>
	<20090617142151.GB6846@elte.hu>
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar writes:

> Note, i've created a new branch, tip:perfcounters/powerpc, so we can 
> keep these things separate and Ben can pull them too. I see there 
> was some review feedback - do you want to send a v2 version perhaps?

Kumar's comments seemed to me to be wanting changes to accommodate
code that doesn't exist yet, so I think those changes should be done
later when that code exists and we know exactly what is needed.  So
the current patches are fine as-is IMO.

Paul.
