Return-Path: <linux-kernel-owner+w=401wt.eu-S1756886AbZEZVKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886AbZEZVKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:10:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755250AbZEZVK0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:10:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62411 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbZEZVK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:10:26 -0400
Date: Tue, 26 May 2009 17:10:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 0/5] tracing/core: various fixes
In-Reply-To: <20090526200640.GD5969@nowhere>
Message-ID: <alpine.DEB.2.00.0905261709470.26705@gandalf.stny.rr.com>
References: <1243303490-8019-1-git-send-email-fweisbec@gmail.com> <alpine.DEB.2.00.0905261542230.26705@gandalf.stny.rr.com> <20090526200640.GD5969@nowhere>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 26 May 2009, Frederic Weisbecker wrote:
> 
> 
> So, should I zap these patches from the pull request?
> Or do you think about a delta solution?

No, keep the config changes out for now.

-- Steve
