Return-Path: <linux-kernel-owner+w=401wt.eu-S934238AbXC0WtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934238AbXC0WtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 18:49:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934268AbXC0WtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 18:49:12 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:54758 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934238AbXC0WtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 18:49:11 -0400
In-Reply-To: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
References: <20070327224401.17758.17852.sendpatchset@tetsuo.zabbo.net>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <B323492B-D01F-42B1-8AC5-DF872E326AEC@oracle.com>
Cc: linux-aio@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Transfer-Encoding: 7bit
From: Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] aio: remove bare user-triggerable error printk
Date: Tue, 27 Mar 2007 15:49:08 -0700
To: Zach Brown <zach.brown@oracle.com>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> We don't need this printk all, just remove it.

("at all".  Sigh.)

- z
