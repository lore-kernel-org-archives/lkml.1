Return-Path: <linux-kernel-owner+w=401wt.eu-S1753947AbYFGERe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753947AbYFGERe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2008 00:17:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751013AbYFGERY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jun 2008 00:17:24 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:60950 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956AbYFGERX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2008 00:17:23 -0400
Date: Sat, 07 Jun 2008 13:16:09 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [PATCH] cgroup: anotate two variables with __read_mostly
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Paul Menage <menage@google.com>
In-Reply-To: <48478187.7080204@cn.fujitsu.com>
References: <48478187.7080204@cn.fujitsu.com>
Message-Id: <20080607131513.9C37.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> - need_forkexit_callback will be read only after system boot.
> - use_task_css_set_links will be read only after it's set.
> 
> And these 2 variables are checked when a new process is forked.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

nice :)
	Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>



