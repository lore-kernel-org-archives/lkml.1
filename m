Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXI1Prr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXI1Prr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 11:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbXI1Prk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 11:47:40 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:49203 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbXI1Prj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 11:47:39 -0400
Message-ID: <46FD21F8.9030202@oracle.com>
Date: Fri, 28 Sep 2007 08:47:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 1.5.0.5 (X11/20060719)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/5] Add samples subdir
References: <20070928142845.795281397@polymtl.ca> <20070928143159.638289605@polymtl.ca>
In-Reply-To: <20070928143159.638289605@polymtl.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Begin infrastructure for kernel code samples in the samples/ directory.
> Add its Kconfig and Kbuild files.
> Source its Kconfig file in all arch/ Kconfigs.
> 
> Changelog:
> - Move menu to Kernel Hacking
> - Don't build with the kernel image
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

I think that this one is S-O-B by both of us.

-- 
~Randy
Phaedrus says that Quality is about caring.
