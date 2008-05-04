Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbYEDP2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbYEDP2S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 11:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751765AbYEDP2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 11:28:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39515 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbYEDP2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 11:28:05 -0400
From: kamezawa.hiroyu@jp.fujitsu.com
Message-ID: <28343987.1209914862098.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 5 May 2008 00:27:42 +0900 (JST)
To: kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: Re: [-mm][PATCH 0/4] Add rlimit controller to cgroups (v3)
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: @nifty Webmail 2.0
References: <23630056.1209914669637.kamezawa.hiroyu@jp.fujitsu.com>
 <20080503213726.3140.68845.sendpatchset@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>   "+This controller framework is designed to be extensible to control any
>   "+resource limit (memory related) with little effort."
>   memory only ? Ok, all you want to do is related to memory, but someone
>   may want to limit RLIMIT_CPU by group or RLIMIT_CORE by group or....
>   (I have no plan but they seems useful.;)
...RLIMIT_MEMLOCK is in my want-to-do-list ;)

Thanks,
-Kame
