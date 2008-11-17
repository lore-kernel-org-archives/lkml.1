Return-Path: <linux-kernel-owner+w=401wt.eu-S1756361AbYKQFg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756361AbYKQFg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 00:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbYKQFgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 00:36:50 -0500
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:47842 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750997AbYKQFgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 00:36:50 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhIFAMuRIElMQW5N/2dsb2JhbACBbMwrgnk
Date: Mon, 17 Nov 2008 00:36:46 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhaolei <zhaolei@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [patch 16/16]
	marker_synchronize_unregister->tracepoint_synchronize_unregister
Message-ID: <20081117053646.GB28750@Krystal>
References: <20081114224733.364965865@polymtl.ca> <20081114224949.751661181@polymtl.ca> <20081116074851.GA530@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20081116074851.GA530@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:31:43 up  6:12,  2 users,  load average: 0.01, 0.06, 0.09
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Impact: documentation update.
> > 
> > Signed-off-by: Zhaolei <zhaolei@cn.fujitsu.com>
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> > CC: Ingo Molnar <mingo@elte.hu>
> > CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> This should have been:
> 
> From: Zhaolei <zhaolei@cn.fujitsu.com>
> 
> correct?
> 
> I updated the patch accordingly.
> 

Yes, that's correct. I forgot to add this line. Thanks !

Mathieu

> 	Ingo

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
