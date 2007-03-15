Return-Path: <linux-kernel-owner+w=401wt.eu-S933386AbXCOIqV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933386AbXCOIqV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 04:46:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933452AbXCOIqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 04:46:21 -0400
Received: from wlserva2.wldelft.nl ([145.9.150.101]:57343 "EHLO wldelft.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933386AbXCOIqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 04:46:21 -0400
Message-ID: <45F90796.4060104@wldelft.nl>
Date: Thu, 15 Mar 2007 09:45:10 +0100
From: Leroy van Logchem <leroy.vanlogchem@wldelft.nl>
User-Agent: Thunderbird 1.5.0.10 (X11/20070306)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, akpm@osdl.org, rdunlap@xenotime.net,
       mingo@elte.hu, stable@kernel.org, roland@redhat.com
Subject: Re: [stable] [PATCH] Fix COMPAT_VDSO regression bug
References: <45F88780.1080507@wldelft.nl> <20070315034555.GC6842@kroah.com>
In-Reply-To: <20070315034555.GC6842@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Mar 15, 2007 at 12:38:40AM +0100, Leroy van Logchem wrote:
>   
>>     Revert "[PATCH] Fix CONFIG_COMPAT_VDSO"
>>     This reverts commit a1f3bb9ae4497a2ed3eac773fd7798ac33a0371f.
>>
>>     Several systems couldnt boot using CONFIG_HIGHMEM64G=y as
>>     reported in bug #8040. Reverting the above patch solved the problem.
>>     
>
> What stable version did you revert this in that solved your problem?
>   
v2.6.20.3

--
Leroy
