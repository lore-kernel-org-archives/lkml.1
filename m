Return-Path: <linux-kernel-owner+w=401wt.eu-S1754764AbXH3Fhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764AbXH3Fhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 01:37:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbXH3Fh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 01:37:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55550 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441AbXH3Fh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 01:37:26 -0400
Date: Thu, 30 Aug 2007 14:38:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Dave Hansen <haveblue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [-mm PATCH] Memory controller improve user interface
Message-Id: <20070830143859.e9d3511a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <46D5F517.1080809@linux.vnet.ibm.com>
References: <20070829111030.9987.8104.sendpatchset@balbir-laptop>
	<1188413148.28903.113.camel@localhost>
	<46D5ED5C.9030405@linux.vnet.ibm.com>
	<1188425894.28903.140.camel@localhost>
	<6599ad830708291520t2bc9ea20m2bdcd9e042b3a423@mail.gmail.com>
	<1188426352.28903.143.camel@localhost>
	<46D5F517.1080809@linux.vnet.ibm.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Aug 2007 04:07:11 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 1. Several people recommended it
> 2. Herbert mentioned that they've moved to that interface and it
>    was working fine for them.
> 

I have no strong opinion. But how about Mega bytes ? (too big ?)
There will be no rounding up/down problem.

-Kame.

