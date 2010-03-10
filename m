Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab0CJSe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 13:34:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752079Ab0CJSe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 13:34:27 -0500
Date: Wed, 10 Mar 2010 19:33:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: Q: select_fallback_rq() && cpuset_lock()
Message-ID: <20100310183259.GA23648@redhat.com>
References: <20100309180615.GA11681@redhat.com> <1268239242.5279.46.camel@twins> <20100310173018.GA1294@redhat.com> <1268244075.5279.53.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268244075.5279.53.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10, Peter Zijlstra wrote:
>
> Right, so if you refresh these patches, I'll feed them to mingo and they
> should eventually end up in -linus, how's that? :-)

Great. Will redo/resend tomorrow ;)

Oleg.

