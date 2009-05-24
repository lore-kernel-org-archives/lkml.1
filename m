Return-Path: <linux-kernel-owner+w=401wt.eu-S1752033AbZEXFQO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbZEXFQO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 01:16:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751120AbZEXFQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 01:16:00 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57742 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbZEXFP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 01:15:59 -0400
Date: Sun, 24 May 2009 14:15:05 +0900 (JST)
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] convert block trace points to TRACE_EVENT()
Cc: kosaki.motohiro@jp.fujitsu.com, Li Zefan <lizf@cn.fujitsu.com>,
       Jeff Moyer <jmoyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jens Axboe <jens.axboe@oracle.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
       Steven Whitehouse <swhiteho@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090523124018.GA15163@infradead.org>
References: <4A13C19E.3000303@cn.fujitsu.com> <20090523124018.GA15163@infradead.org>
Message-Id: <20090524141347.0841.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, May 20, 2009 at 04:38:54PM +0800, Li Zefan wrote:
> > Yes, this patch doesn't affect ioctl-based blktrace or ftrace-plugin
> > blktrace at all.
> 
> Is there any good reason for keeping the ftrace plugin once we have
> the fully function event tracer support for the block events?

waiting userland blktrace tool convert using event tracer? 

just guess :-)



