Return-Path: <linux-kernel-owner+w=401wt.eu-S1755105AbZCTNHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755105AbZCTNHu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 09:07:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZCTNHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 09:07:40 -0400
Received: from mx2.redhat.com ([66.187.237.31]:45514 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752325AbZCTNHk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 09:07:40 -0400
Date: Fri, 20 Mar 2009 10:07:14 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] blktrace: remove
	sysfs_blk_trace_enable_show/store()
Message-ID: <20090320130714.GL30407@ghostprotocols.net>
References: <49C2F599.3060306@cn.fujitsu.com> <49C2F628.9090300@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49C2F628.9090300@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Mar 20, 2009 at 09:49:28AM +0800, Li Zefan escreveu:
> sysfs_blk_trace_enable_show()/store() share most of code with
> sysfs_blk_trace_attr_show()/store().
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Nice consolidation, thanks!

Acked-by: Arnaldo Carvalho de Melo <acme@redhat.com>

- Arnaldo
