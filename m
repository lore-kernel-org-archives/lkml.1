Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYBNRZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYBNRZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754102AbYBNRZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:25:42 -0500
Received: from tetsuo.zabbo.net ([207.173.201.20]:57522 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752256AbYBNRZl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:25:41 -0500
Message-ID: <47B47994.7020804@oracle.com>
Date: Thu, 14 Feb 2008 09:25:40 -0800
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/6] fs/direct-io.c: Use DIV_ROUND_UP
References: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
In-Reply-To: <Pine.LNX.4.58.0802141614050.1185@pc-041.diku.dk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Julia Lawall wrote:
> From: Julia Lawall <julia@diku.dk>
> 
> The kernel.h macro DIV_ROUND_UP performs the computation (((n) + (d) - 1) /
> (d)) but is perhaps more readable.

It certainly looks better to me, thanks for doing this.

> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-By: Zach Brown <zach.brown@oracle.com>

- z
