Return-Path: <linux-kernel-owner+w=401wt.eu-S1765655AbYBNMv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765655AbYBNMv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753939AbYBNMvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:51:49 -0500
Received: from relay2.sgi.com ([192.48.171.30]:56798 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753775AbYBNMvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:51:48 -0500
Date: Thu, 14 Feb 2008 06:51:44 -0600
From: Paul Jackson <pj@sgi.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: cpw@sgi.com, simon.derr@bull.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kernel/cpuset.c: make 3 functions static
Message-Id: <20080214065144.ffa15772.pj@sgi.com>
In-Reply-To: <20080213213031.GG3383@cs181133002.pp.htv.fi>
References: <20080213213031.GG3383@cs181133002.pp.htv.fi>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian wrote:
> This patch makes the following needlessly global functions static:
> - cpuset_test_cpumask()
> - cpuset_change_cpumask()
> - cpuset_do_move_task()

Thanks.

Signed-off-by: Paul Jackson <pj@sgi.com>

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
