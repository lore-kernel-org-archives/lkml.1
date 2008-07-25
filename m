Return-Path: <linux-kernel-owner+w=401wt.eu-S1754454AbYGYBtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbYGYBtW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 21:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751932AbYGYBtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 21:49:13 -0400
Received: from ozlabs.org ([203.10.76.45]:42180 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbYGYBtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 21:49:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] kernel/module.c: fix a build warning
Date: Fri, 25 Jul 2008 11:48:59 +1000
User-Agent: KMail/1.9.9
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20080724144148.GM2993@hack.voiplan.pt>
In-Reply-To: <20080724144148.GM2993@hack.voiplan.pt>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200807251148.59478.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 July 2008 00:41:48 WANG Cong wrote:
> This patch fixed the warning:
>
>   CC      kernel/module.o
>   /home/wangcong/Projects/linux-2.6/kernel/module.c:332: warning:
> ‘lookup_symbol’ defined but not used
>
>
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: rusty@rustcorp.com.au

Thanks, applied!

Rusty.
