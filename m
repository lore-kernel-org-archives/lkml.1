Return-Path: <linux-kernel-owner+w=401wt.eu-S1757493AbYEMDLq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493AbYEMDLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754261AbYEMDLi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:11:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:40481 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbYEMDLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:11:37 -0400
Message-ID: <482906A9.50909@jp.fujitsu.com>
Date: Tue, 13 May 2008 12:10:33 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Jackson <pj@sgi.com>,
       Paul Menage <menage@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuset: limit the input of cpuset.sched_relax_domain_level
References: <4828FC85.7020400@cn.fujitsu.com>
In-Reply-To: <4828FC85.7020400@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> We allow the inputs to be [-1 ... SD_LV_MAX), and return -EINVAL
> for inputs outside this range.

Looks good to me. Thanks!

H.Seto
