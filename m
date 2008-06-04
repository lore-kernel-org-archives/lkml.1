Return-Path: <linux-kernel-owner+w=401wt.eu-S1758873AbYFDHpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758873AbYFDHpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 03:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750971AbYFDHpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 03:45:22 -0400
Received: from main.gmane.org ([80.91.229.2]:51783 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758732AbYFDHpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 03:45:12 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: linux-next: WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
Date: Wed, 04 Jun 2008 08:45:01 +0100
Message-ID: <g25h5s$t3h$1@ger.gmane.org>
References: <4844868F.20104@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kevin Winchester wrote:

> In next-20080530 and next-20080602 (and possibly earlier - I can't
> remember the linux-next tree before that I tried) I get the following:
> 
> [   12.885153] ------------[ cut here ]------------
> [   12.885203] WARNING: at kernel/lockdep.c:2680 check_flags+0x98/0x151()
> [   12.885248] Pid: 4, comm: watchdog/0 Not tainted
> 
> This is completely reproducible on every boot - should I try to bisect it?

If you are going to bisect it seems to me that the problem seems to have
occurred between next-20080526 and next-20080527...

-- 
Sitsofe | http://sucs.org/~sits/

