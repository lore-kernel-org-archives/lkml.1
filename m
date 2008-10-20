Return-Path: <linux-kernel-owner+w=401wt.eu-S1752069AbYJTClr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069AbYJTClr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2008 22:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYJTCli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Oct 2008 22:41:38 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:22945 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751073AbYJTClh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2008 22:41:37 -0400
Date: Mon, 20 Oct 2008 11:41:19 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: linux-sh@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix debugfs_create_dir's error checking method for arch/sh/kernel/
Message-ID: <20081020024119.GC19416@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Zhaolei <zhaolei@cn.fujitsu.com>, linux-sh@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <48F87615.60302@cn.fujitsu.com> <48F8760F.4070909@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48F87615.60302@cn.fujitsu.com> <48F8760F.4070909@cn.fujitsu.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 17, 2008 at 07:25:03PM +0800, Zhaolei wrote:
> debugfs_create_dir() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

On Fri, Oct 17, 2008 at 07:25:09PM +0800, Zhaolei wrote:
> debugfs_create_file() returns NULL if an error occurs, returns -ENODEV
> when debugfs is not enabled in the kernel.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>

Applied, thanks.
