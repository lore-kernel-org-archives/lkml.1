Return-Path: <linux-kernel-owner+w=401wt.eu-S934369AbZKYDl0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934369AbZKYDl0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 22:41:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934316AbZKYDlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 22:41:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:61876 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933823AbZKYDlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 22:41:24 -0500
Subject: Re: [PATCH] tracing: separate raw syscall from syscall tracer
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4B0C918E.1070101@cn.fujitsu.com>
References: <4AEFC37C.5080609@cn.fujitsu.com>
	 <20091103082311.GA4815@nowhere>  <4B0C918E.1070101@cn.fujitsu.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 22:41:28 -0500
Message-Id: <1259120488.22249.1130.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-11-25 at 10:08 +0800, Lai Jiangshan wrote:
> Frederic Weisbecker wrote:
> > On Tue, Nov 03, 2009 at 01:45:32PM +0800, Lai Jiangshan wrote:

> > 
> > Agreed, that's indeed not convenient.
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > 
> > 
> 
> Hi, Steven
> 
> Could you accept this patch?
> 

Will do,

Thanks,

-- Steve


