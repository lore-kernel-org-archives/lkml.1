Return-Path: <linux-kernel-owner+w=401wt.eu-S933099AbXEUU2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099AbXEUU2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759974AbXEUU2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:28:06 -0400
Received: from h155.mvista.com ([63.81.120.158]:61188 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1757101AbXEUU2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:28:03 -0400
Subject: Re: v2.6.21-rt3
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
In-Reply-To: <1179779053.12708.45.camel@chaos>
References: <20070517194143.GA25394@elte.hu>
	 <1179778266.15427.38.camel@imap.mvista.com>
	 <1179779053.12708.45.camel@chaos>
Content-Type: text/plain
Date: Mon, 21 May 2007 13:25:42 -0700
Message-Id: <1179779142.15427.44.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-05-21 at 22:24 +0200, Thomas Gleixner wrote:
> On Mon, 2007-05-21 at 13:11 -0700, Daniel Walker wrote:
> > Where did the arm ep93xx changes come from? 
> 
> Grown out of my nose probably.
> 
> > It looks like patch below
> > came in with them in 2.6.21-rt6 ..
> 
> So what ?

It's silencing a WARN_ON() with no real reason why it's happening, or
why/if it's safe to silence it .. Why is that there?

Daniel

