Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZGWDst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZGWDst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 23:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZGWDss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 23:48:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:36656 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376AbZGWDsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 23:48:47 -0400
Message-ID: <4A67DD9D.8030304@windriver.com>
Date: Wed, 22 Jul 2009 22:48:45 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next:  kgdb tree fetch failure
References: <20090723090956.e6024af4.sfr@canb.auug.org.au><4A67D36D.8070209@windriver.com> <20090723133842.30ae062b.sfr@canb.auug.org.au>
In-Reply-To: <20090723133842.30ae062b.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2009 03:48:46.0290 (UTC) FILETIME=[7B042320:01CA0B48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> Hi Jason,
>
>   
>> My local git repository completely bailed, so I am going to reconstruct
>> the kgdb branches from a new clone.  There was no obvious way to recover
>> my archive. 
>>     
>
>   

As luck would have it, the pull of 2.6.31-rc4 magically fixed the local
archive, so kgdb-next branch is back in sync and updated.

Thanks,
Jason.
