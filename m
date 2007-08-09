Return-Path: <linux-kernel-owner+w=401wt.eu-S1765208AbXHIHFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765208AbXHIHFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 03:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937808AbXHIHFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 03:05:33 -0400
Received: from www.osadl.org ([213.239.205.134]:52578 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S937745AbXHIHFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 03:05:32 -0400
Subject: Re: [PATCH] timer:Remove clockevents_unregister_notifier
From: Thomas Gleixner <tglx@linutronix.de>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <46BA7A9E.1090802@cn.fujitsu.com>
References: <46BA7A9E.1090802@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 09 Aug 2007 09:05:28 +0200
Message-Id: <1186643128.12828.1.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-08-09 at 11:23 +0900, Miao Xie wrote:
> Hi everyone,
> 
>    I find a function(clockevents_unregister_notifier) which is not
> called by anything in tree.
> 
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>

Acked-by: Thomas Gleixner <tglx@linutronix.de>


