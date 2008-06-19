Return-Path: <linux-kernel-owner+w=401wt.eu-S1756937AbYFSGMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbYFSGMx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 02:12:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753620AbYFSGMp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 02:12:45 -0400
Received: from mga05.intel.com ([192.55.52.89]:44454 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753267AbYFSGMp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 02:12:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,671,1204531200"; 
   d="scan'208";a="579551528"
Message-ID: <4859F8CE.7010203@linux.intel.com>
Date: Wed, 18 Jun 2008 23:12:30 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
References: <4859EFE2.2090202@linux.intel.com> <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806182242390.2907@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> One thing I note is that all the oopses seem to be i686 - are there that 
> few x86-64 fc10 users (I'd have assumed that 64-bit is starting to be the 
> norm for people who live on the edge, but perhaps I'm just out of touch)? 
> 

for rawhide the 64/32 ratio seems to be 106/135
for fedora 9 the 64/32 ratio is 4946/13636

(nr of oopses for the specific architecture/releases)

so your assumption of the experimental rawhide users are more likely to use 64 bit seems to be quite correct.
