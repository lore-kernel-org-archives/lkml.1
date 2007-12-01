Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbXLAWju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbXLAWju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 17:39:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751934AbXLAWjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 17:39:44 -0500
Received: from phunq.net ([64.81.85.152]:39569 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751864AbXLAWjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 17:39:43 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Low Yucheng <ylow@andrew.cmu.edu>
Subject: Re: PROBLEM: System Freeze on Particular workload with kernel 2.6.22.6
Date: Sat, 1 Dec 2007 14:39:33 -0800
User-Agent: KMail/1.9.5
Cc: Oleg Verych <olecom@flower.upol.cz>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
References: <46F0E19D.8000400@andrew.cmu.edu> <E1IY1mO-00067S-7v@flower> <46F14B67.5010807@andrew.cmu.edu>
In-Reply-To: <46F14B67.5010807@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712011439.34605.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmm, I wonder if this had something to do with it:

> [   25.856573] VFS: Disk quotas dquot_6.5.1

Was the system still pingable?

Regards,

Daniel
