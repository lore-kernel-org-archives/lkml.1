Return-Path: <linux-kernel-owner+w=401wt.eu-S1753579AbZLTKdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbZLTKdd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 05:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753292AbZLTKdc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 05:33:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64404 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753283AbZLTKdb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 05:33:31 -0500
Message-ID: <4B2DFD08.9010507@cn.fujitsu.com>
Date: Sun, 20 Dec 2009 18:31:36 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf record: We should fork only if a program was
 specified to run
References: <1261168944-6615-1-git-send-email-acme@infradead.org>
In-Reply-To: <1261168944-6615-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> IOW: Now 'perf record -a' works, this was a bug introduced in:
> 
> 856e96608a72412d319e498a3a7c557571f811bd
> "perf record: Properly synchronize child creation"
> 

Sorry, i not noticed this patch and also send a patch to fix this bug,
See:
	http://lkml.org/lkml/2009/12/20/7

please ignore my patch.

Thanks,
Xiao
