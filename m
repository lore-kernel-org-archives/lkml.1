Return-Path: <linux-kernel-owner+w=401wt.eu-S1760152AbYDQIzD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152AbYDQIzD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 04:55:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363AbYDQIyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 04:54:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56704 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750822AbYDQIyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 04:54:52 -0400
Date: Thu, 17 Apr 2008 01:54:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [v2.6.26] what's brewing in x86.git for v2.6.26
Message-Id: <20080417015425.312d34c0.akpm@linux-foundation.org>
In-Reply-To: <20080417.014534.258800340.davem@davemloft.net>
References: <20080417002552.5742ad65.akpm@linux-foundation.org>
	<20080417083000.GA4935@elte.hu>
	<20080417014054.ea788f1f.akpm@linux-foundation.org>
	<20080417.014534.258800340.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2008 01:45:34 -0700 (PDT) David Miller <davem@davemloft.net> wrote:

> From: Andrew Morton <akpm@linux-foundation.org>
> Date: Thu, 17 Apr 2008 01:40:54 -0700
> 
> > By keeping all this code out of -mm you haven't solved any of the
> > merge/integration problems which we had in 2.6.24-rcX.
> 
> I think things would have been a lot easier if you had adopted
> basing -mm on top of linux-next from the very start.

linux-next ramped up across the 2.6.25-rc window and I wanted to give it
some time to see how it would pan out.

> The responsiveness to problems and merge hassles has been so much
> superior and efficient from the linux-next folks for my networking
> stuff, for example.  It's never been like that with -mm.

I don't know what you mena by this.  But linux-next integrates only the
other subsystem trees and they have rarely caused me integration problems
against git-net.  
