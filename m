Return-Path: <linux-kernel-owner+w=401wt.eu-S1761367AbYGRCn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761367AbYGRCn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 22:43:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756798AbYGRCnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 22:43:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:33464 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755968AbYGRCnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 22:43:10 -0400
Date: Thu, 17 Jul 2008 21:43:07 -0500
From: Paul Jackson <pj@sgi.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: seto.hidetoshi@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       menage@google.com, peterz@infradead.org, akpm@linux-foundation.org,
       laijs@cn.fujitsu.com
Subject: Re: [RFC] [PATCH] cpuset: fix wrong calculation of relax domain
 level
Message-Id: <20080717214307.4bb853ae.pj@sgi.com>
In-Reply-To: <488001BF.1070006@cn.fujitsu.com>
References: <487EFDD0.2060101@cn.fujitsu.com>
	<20080717152833.1e14a1c4.pj@sgi.com>
	<488001BF.1070006@cn.fujitsu.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It was your idea to use the largest sched_load_balance for overlapping cpusets.

Yes ... quite so ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
