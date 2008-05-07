Return-Path: <linux-kernel-owner+w=401wt.eu-S1757823AbYEGBEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757823AbYEGBEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:04:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbYEGBEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:04:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35160 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752974AbYEGBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:04:44 -0400
Date: Wed, 7 May 2008 10:09:35 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: linux-mm@kvack.org, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm][PATCH 0/4] Add rlimit controller to cgroups (v3)
Message-Id: <20080507100935.28316ff7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <481E8B3F.3050508@linux.vnet.ibm.com>
References: <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
	<23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com>
	<481E8B3F.3050508@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 May 2008 09:51:19 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > 3. Rleated to 2. Showing what kind of "rlimit" params are supported by
> >    cgroup will be good.
> > 
> 
> Do you mean in init/Kconfig or documentation?. I should probably rename
> limit_in_bytes and usage_in_bytes to add an as_ prefix, so that the UI clearly
> shows what is supported as well.
I see.

Thanks,
-Kame

