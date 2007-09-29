Return-Path: <linux-kernel-owner+w=401wt.eu-S1756620AbXI2Bvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756620AbXI2Bvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753250AbXI2Bvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:51:43 -0400
Received: from phunq.net ([64.81.85.152]:60187 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753238AbXI2Bvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:51:43 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: KDB?
Date: Fri, 28 Sep 2007 18:51:24 -0700
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com> <20070928114930.2c201324.akpm@linux-foundation.org> <1191006971.6702.25.camel@heimdal.trondhjem.org>
In-Reply-To: <1191006971.6702.25.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281851.24752.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 12:16, Trond Myklebust wrote:
> crash> bt 3188

crash> ps|grep ps

Hey, that looks just like kdb!  But I heard that kgdb is better in every 
way than kdb.

Innocently yours,

Daniel
