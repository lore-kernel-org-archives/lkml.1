Return-Path: <linux-kernel-owner+w=401wt.eu-S1763714AbXLNVKl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763714AbXLNVKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:10:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753161AbXLNVKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:10:32 -0500
Received: from phunq.net ([64.81.85.152]:54172 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752689AbXLNVKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:10:31 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 16/29] netvm: INET reserves.
Date: Fri, 14 Dec 2007 13:10:27 -0800
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071214153907.770251000@chello.nl> <20071214154441.337409000@chello.nl>
In-Reply-To: <20071214154441.337409000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141310.27690.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

sysctl_intvec_fragment, proc_dointvec_fragment, sysctl_intvec_fragment 
seem to suffer from cut-n-pastitis.

Regards,

Daniel
