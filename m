Return-Path: <linux-kernel-owner+w=401wt.eu-S934019AbZGQCfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934019AbZGQCfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 22:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934006AbZGQCfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 22:35:22 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:58643 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934000AbZGQCfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 22:35:22 -0400
Date: Fri, 17 Jul 2009 08:05:19 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] cgroup avoid permanent sleep at rmdir v7
Message-ID: <20090717023519.GG3576@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090703093154.5f6e910a.kamezawa.hiroyu@jp.fujitsu.com> <20090716145534.07511d67.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090716145534.07511d67.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-07-16 14:55:34]:

> Rebased onto mm-of-the-moment snapshot 2009-07-15-20-57.
> passed fundamental tests.

Andrew could you please pick this up, it is an important bugfix and if
possible needs to go into 2.6.31-rcX. Does anybody object to that or
should we wait till 2.6.32-rc1?

-- 
	Balbir
