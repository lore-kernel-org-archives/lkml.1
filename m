Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbYBRKuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbYBRKuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:50:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYBRKuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:50:04 -0500
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:53322 "EHLO
	e28esmtp02.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755619AbYBRKuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:50:02 -0500
Date: Mon, 18 Feb 2008 16:19:35 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Aneesh Kumar KV <aneesh.kumar@linux.vnet.ibm.com>, efault@gmx.de
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: sched-devel latencies
Message-ID: <20080218104933.GA18817@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I am running the sched-devel tree (at HEAD
44e770a8750abc7e876076cda718b413bad9e654) and it is not looking good.

I am running two "make -j"s for the kernel in two different cgroups and
interactivity is going for a toss. I can see noticable lags in
keypresses.

Will get down to debugging it further a bit later on.

-- 
regards,
Dhaval
