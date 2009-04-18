Return-Path: <linux-kernel-owner+w=401wt.eu-S1754552AbZDRGnp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbZDRGnp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 02:43:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752742AbZDRGng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 02:43:36 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40888 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbZDRGnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 02:43:35 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Lameter <cl@linux.com>
Subject: Re: AIM9 from 2.6.22 to 2.6.29
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
In-Reply-To: <alpine.DEB.1.10.0904161616001.17864@qirst.com>
References: <alpine.DEB.1.10.0904161616001.17864@qirst.com>
Message-Id: <20090418154207.1260.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50 [ja]
Date: Sat, 18 Apr 2009 15:43:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is a list of AIM9 results for all kernels between 2.6.22 2.6.29:
> 
> Significant regressions:
> 
> creat-clo
> page_test

I'm interest to it.
How do I get AIM9 benchmark?

and, Can you compare CONFIG_UNEVICTABLE_LRU is y and n?


> brk_test
> exec_test
> fork_test (!!)
> shell_*
> fifo_test
> pipe_cpy
> 
> Significant improvements:
> 
> signal_test
> tcp_test
> udp_test


