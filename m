Return-Path: <linux-kernel-owner+w=401wt.eu-S1756176AbZJ2BU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756176AbZJ2BU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756020AbZJ2BU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:20:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41407 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755991AbZJ2BU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:20:26 -0400
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256767637.2683.410.camel@sbs-t61.sc.intel.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
	 <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
	 <1256686285.26028.487.camel@gandalf.stny.rr.com>
	 <1256759778.2683.185.camel@sbs-t61.sc.intel.com>
	 <1256760953.26028.1770.camel@gandalf.stny.rr.com>
	 <1256767637.2683.410.camel@sbs-t61.sc.intel.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Wed, 28 Oct 2009 21:20:29 -0400
Message-Id: <1256779229.26028.2089.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-10-28 at 14:07 -0800, Suresh Siddha wrote:

> Will send another patch to fix this too. You are ok with the ftrace
> change right? I will send both of these shortly.

Yep, I thoroughly tested your ftrace change. Looks good. You can even
add a "Tested-by" me too. I took out my previous change, and your patch
worked fine.

Just worried about the other side effects that we discussed. But that
has nothing to do with ftrace.

Thanks,

-- Steve


