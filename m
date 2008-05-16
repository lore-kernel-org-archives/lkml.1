Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbYEPQad@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbYEPQad (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 12:30:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752001AbYEPQaY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 12:30:24 -0400
Received: from relay1.sgi.com ([192.48.171.29]:44376 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751585AbYEPQaX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 12:30:23 -0400
Date: Fri, 16 May 2008 11:30:21 -0500
From: Paul Jackson <pj@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: ying.huang@intel.com, hpa@zytor.com, andi@firstfloor.org,
       akpm@linux-foundation.org, tglx@linutronix.de, steiner@sgi.com,
       travis@sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI
 memory entries to kernel
Message-Id: <20080516113021.42a4d3b2.pj@sgi.com>
In-Reply-To: <20080516123820.GA16520@elte.hu>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
	<20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
	<20080515190340.b232ca7d.pj@sgi.com>
	<20080516123820.GA16520@elte.hu>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo wrote:
> i've queued up your changes to the -tip tree 

Thanks.

> so double-checking it [the merge ontop of Yinghai's e820 work] would be nice.

Ok - will do.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
