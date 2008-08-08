Return-Path: <linux-kernel-owner+w=401wt.eu-S1762090AbYHHWXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762090AbYHHWXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 18:23:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYHHWX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 18:23:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57529 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751180AbYHHWX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 18:23:28 -0400
Message-ID: <489CC74B.6060800@kernel.org>
Date: Fri, 08 Aug 2008 15:23:07 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: akataria@vmware.com
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       Zach Amsden <zach@vmware.com>, Ingo Molnar <mingo@elte.hu>,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]Fix broken VMI in 2.6.27-rc..
References: <1218136365.23770.52.camel@alok-dev1>	 <489B6710.9000604@kernel.org>	 <1218144438.20178.336.camel@bodhitayantram.eng.vmware.com>	 <489B6A5C.8030400@kernel.org>	 <1218145344.20178.347.camel@bodhitayantram.eng.vmware.com>	 <489B6E83.7000202@kernel.org> <1218222957.26510.16.camel@alok-dev1>
In-Reply-To: <1218222957.26510.16.camel@alok-dev1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alok Kataria wrote:
> 
> Ok, since we are already past rc-2, I think we should fix the VMI
> problem sooner than later.  Any approach that we eventually take to make
> the fixmap's actually *fixed*, would be independent of this fix. 
> 

Agreed.  Applied to tip:x86/urgent.  Thanks!

	-hpa
