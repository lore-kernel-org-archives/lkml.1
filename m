Return-Path: <linux-kernel-owner+w=401wt.eu-S1757898AbYFSNk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898AbYFSNk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 09:40:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbYFSNkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 09:40:20 -0400
Received: from mga10.intel.com ([192.55.52.92]:26058 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754994AbYFSNkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 09:40:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,672,1204531200"; 
   d="scan'208";a="343327744"
Message-ID: <485A61B5.90003@linux.intel.com>
Date: Thu, 19 Jun 2008 06:40:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: Dave Airlie <airlied@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: kerneloops.org: 2.6.26-rc possible regression in ext3
References: <4859F075.2050207@linux.intel.com> <21d7e9970806182242na130e47i85839c4550b4ba03@mail.gmail.com> <20080619081146.GC17630@cs181133002.pp.htv.fi>
In-Reply-To: <20080619081146.GC17630@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> 
> Expect a lot more of this to pop up in the future.
> Should we #error for gcc 4.3.1?
> 

it/s better to find if the gcc guys made a testcase for this bug (they normally do) and
test based on that.
