Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZLIFxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZLIFxO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 00:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751583AbZLIFxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 00:53:09 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41373 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbZLIFxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 00:53:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=kd4J5hv4N5wA:10 a=7U3hwN5JcxgA:10 a=El1qUHjUsNqDrXyVrhoA:9 a=8L6S85lEzhT5HtKsZfijfonpb08A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 00/13] tracing: various cleanups and small fixes
 (updated)
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B1DC476.3030700@cn.fujitsu.com>
References: <4B1DC476.3030700@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 09 Dec 2009 00:53:14 -0500
Message-ID: <1260337994.2146.68.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-08 at 11:13 +0800, Li Zefan wrote:
> Updates:
> 
> - took a further step to save more spaces (01/13)
> - fixed a mistake in (03/13)
> - collected some ACKs

Frederic,

I reviewed the entire patch set. You can add my "Acked-by" to all
patches and apply them, with the changes that you said need to be fixed.

Thanks!

-- Steve


