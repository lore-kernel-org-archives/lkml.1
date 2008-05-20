Return-Path: <linux-kernel-owner+w=401wt.eu-S1762955AbYETJSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762955AbYETJSj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 05:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759268AbYETJSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 05:18:30 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40567 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760934AbYETJS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 05:18:29 -0400
Date: Tue, 20 May 2008 18:23:38 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "yamamoto@valinux.co.jp" <yamamoto@valinux.co.jp>
Subject: Re: [RFC][PATCH 1/3] memcg: documentation for controll file
Message-Id: <20080520182338.a7614fc0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <48329421.8080904@openvz.org>
References: <20080520180552.601da567.kamezawa.hiroyu@jp.fujitsu.com>
	<48329421.8080904@openvz.org>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 May 2008 13:04:33 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Add a documentation for memory resource controller's files.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> I have described some files, that should be created by a control group,
> which uses a res_counter in Documentation/controllers/resource_counter.txt
> section 4.
> 
Ah, sorry. I missed it.

> Maybe it's worth adding a reference to this file, or even rework this
> text? How do you think?
> 
I'll drop parameters from res_coutner and just shows special files for
memory controller and some how-to-use text. (maybe add to memory.txt)

Thanks,
-Kame

