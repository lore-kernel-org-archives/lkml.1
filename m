Return-Path: <linux-kernel-owner+w=401wt.eu-S1752213AbZIQNTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213AbZIQNTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:19:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbZIQNTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:19:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38439 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062AbZIQNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:19:30 -0400
Subject: Re: [PATCH] softirq: Fix softirq_to_name
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Jens Axboe <jens.axboe@oracle.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB20398.8070209@cn.fujitsu.com>
References: <4AB20398.8070209@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 17 Sep 2009 09:19:31 -0400
Message-Id: <1253193571.20020.246.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-09-17 at 17:38 +0800, Li Zefan wrote:
> With BLOCK_IOPOLL_SOFTIRQ added, softirq_to_name[] and

Ug, another softirq added :-(

> show_softirq_name() needs to be updated.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Thanks Li, I'll pull it in.

-- Steve


