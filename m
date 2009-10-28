Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZJ1Ojf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZJ1Ojf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754049AbZJ1Oje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:39:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60554 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbZJ1Oje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:39:34 -0400
Subject: Re: [PATCH] tracing/filters: Fix to make system filter work
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Tom Zanussi <tzanussi@gmail.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4AE810BD.3070009@cn.fujitsu.com>
References: <4AE810BD.3070009@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 10:39:36 -0400
Message-Id: <1256740776.26028.1320.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 17:37 +0800, Li Zefan wrote:
> commit fce29d15b59245597f7f320db4a9f2be0f5fb512
> ("tracing/filters: Refactor subsystem filter code")
> broke system filter accidentally.

Thanks Li!

I'll pull this in and send it off to Ingo, in case he has not already
done so.

-- Steve


