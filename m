Return-Path: <linux-kernel-owner+w=401wt.eu-S1754846AbYLSXv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846AbYLSXv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 18:51:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751337AbYLSXvp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 18:51:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50277 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961AbYLSXvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 18:51:44 -0500
Message-ID: <494C31C8.1050502@zytor.com>
Date: Fri, 19 Dec 2008 15:44:08 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: venkatesh.pallipadi@intel.com
CC: mingo@elte.hu, tglx@linutronix.de, akpm@linux-foundation.org,
       npiggin@suse.de, hugh@veritas.com, arjan@infradead.org,
       jbarnes@virtuousgeek.org, rdreier@cisco.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [patch 0/5] Changes based on review comments for PAT pfnmap tracking
References: <20081219214725.125171000@intel.com>
In-Reply-To: <20081219214725.125171000@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

venkatesh.pallipadi@intel.com wrote:
> Incremental patches to address the review comments from Nick Piggin
> for v3 version of x86 PAT pfnmap changes patchset here
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0812.2/01330.html
> 

Applied to tip:x86/pat2, thanks!

	-hpa
