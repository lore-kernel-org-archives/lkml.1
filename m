Return-Path: <linux-kernel-owner+w=401wt.eu-S1762185AbXGWWLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762185AbXGWWLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 18:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754660AbXGWWLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 18:11:16 -0400
Received: from www.osadl.org ([213.239.205.134]:50192 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759747AbXGWWLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 18:11:14 -0400
Subject: Re: v2.6.22.1-rt5
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
Cc: Rui Nuno Capela <rncbc@rncbc.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <1185228302.3318.40.camel@chaos>
References: <20070723210236.GA25104@elte.hu>  <46A51D9E.8040104@rncbc.org>
	 <1185226226.2573.147.camel@imap.mvista.com>
	 <1185228302.3318.40.camel@chaos>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 00:11:08 +0200
Message-Id: <1185228668.3318.46.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 00:05 +0200, Thomas Gleixner wrote:
> On Mon, 2007-07-23 at 14:30 -0700, Daniel Walker wrote:
> > Yeah, the quicklist patch wasn't fully tested .. The delta patch below
> > is what I had to change to get it working ..
> 
> My bad. I pushed the wrong queue to Ingo.
> 
> -ENOTENOUGHSLEEP
> 
> This is the delta. We'll do a -rt6 tomorrow morning.

-EWAYNOTENOUGHSLEEP

I sent out the wrong delta. /me goes to sleep and fixes tomorrow.

	tglx


