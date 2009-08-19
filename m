Return-Path: <linux-kernel-owner+w=401wt.eu-S1753198AbZHSU6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198AbZHSU6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Aug 2009 16:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbZHSU6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Aug 2009 16:58:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41481 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752998AbZHSU6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Aug 2009 16:58:33 -0400
Date: Wed, 19 Aug 2009 13:58:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "tina.yang" <tina.yang@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysrq: add debug message to reboot event
Message-Id: <20090819135827.168621d8.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.0908181339310.25797@wotan.suse.de>
References: <4A89AC97.6030109@oracle.com>
	<alpine.LNX.2.00.0908181339310.25797@wotan.suse.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Aug 2009 13:40:24 +0200 (CEST) Jiri Kosina <jkosina@suse.cz> wrote:

> On Mon, 17 Aug 2009, tina.yang wrote:
> 
> > Add debug message to detect keyboard vs non-keyboard
> > triggered sysrq-b events.
> > 
> > Signed-off-by: Tina Yang <Tina.Yang@oracle.com>
> > Signed-off-by: Zach Brown <Zach.Brown@oracle.com>
> > 
>
> ...
>
> 
> I'd rather have this go through -mm, this doesn't really fully qualify for 
> trivial tree. CCing Andrew.

The changelog had no description of why the change should be applied
and I was unable to understand the motivation from reading the patch,
so I skipped it.

Also the patch was wordwrapped and had all its tabs replaced by spaces.
