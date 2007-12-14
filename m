Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXLNVHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXLNVHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 16:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbXLNVHO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 16:07:14 -0500
Received: from phunq.net ([64.81.85.152]:54162 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752862AbXLNVHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 16:07:13 -0500
From: Daniel Phillips <phillips@phunq.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 00/29] Swap over NFS -v15
Date: Fri, 14 Dec 2007 13:07:05 -0800
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no
References: <20071214153907.770251000@chello.nl>
In-Reply-To: <20071214153907.770251000@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712141307.05635.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

A major feature of this patch set is the network receive deadlock 
avoidance, but there is quite a bit of stuff bundled with it, the NFS 
user accounting for a big part of the patch by itself.

Is it possible to provide a before and after demonstration case for just 
the network receive deadlock part, given a subset of the patch set and 
a user space recipe that anybody can try?

Regards,

Daniel

