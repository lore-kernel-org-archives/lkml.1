Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXEJAul@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXEJAul (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:50:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbXEJAue
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:50:34 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:37613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756867AbXEJAud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:50:33 -0400
Date: Wed, 9 May 2007 17:50:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: lguest re-review
Message-Id: <20070509175018.a4a685b8.akpm@linux-foundation.org>
In-Reply-To: <1178756648.7286.182.camel@localhost.localdomain>
References: <20070509025122.f3cb7247.akpm@linux-foundation.org>
	<1178756648.7286.182.camel@localhost.localdomain>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2007 10:24:08 +1000
Rusty Russell <rusty@rustcorp.com.au> wrote:

> On Wed, 2007-05-09 at 02:51 -0700, Andrew Morton wrote:
> > Some concern was expressed over the lguest review status, so I shall send
> > the patches out again for people to review, to test, to make observations
> > about the author's personal appearance, etc.
> 
> Thanks Andrew,
> 
> 	This means I can finally ack this patch (thanks Eric):
> 
> From: ebiederm@xmission.com (Eric W. Biederman)
> Subject: [PATCH] Revert "[PATCH] paravirt: Add startup infrastructure for paravirtualization"
> 
> This reverts commit c9ccf30d77f04064fe5436027ab9d2230c7cdd94.

I don't get it.  Does lguest no longer need this code, or will
it be reintroduced with an lguest merge, or something else?
