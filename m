Return-Path: <linux-kernel-owner+w=401wt.eu-S1758846AbZBRW4f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846AbZBRW4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 17:56:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752886AbZBRW4V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 17:56:21 -0500
Received: from mail.vyatta.com ([76.74.103.46]:52063 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609AbZBRW4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 17:56:19 -0500
Date: Wed, 18 Feb 2009 14:56:16 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: David Miller <davem@davemloft.net>
Cc: peterz@infradead.org, mingo@elte.hu, kaber@trash.net, rick.jones2@hp.com,
       dada1@cosmosbay.com, netdev@vger.kernel.org,
       netfilter-devel@vger.kernel.org, tglx@linutronix.de,
       gandalf@wlug.westbo.se, linux-kernel@vger.kernel.org
Subject: Re: [RFT 2/4] Add mod_timer_noact
Message-ID: <20090218145616.619a60c3@extreme>
In-Reply-To: <20090218.144741.226638312.davem@davemloft.net>
References: <20090218215140.GA3505@elte.hu>
	<20090218.140455.142445208.davem@davemloft.net>
	<1234996947.4799.29.camel@laptop>
	<20090218.144741.226638312.davem@davemloft.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Feb 2009 14:47:41 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 18 Feb 2009 23:42:27 +0100
> 
> > Can we please leave it at this, the technical issue seems to be delt
> > with. You and Ingo seems to have a gift to rub each other the wrong way,
> > it would be grand if you could both try to be a little forgiving and
> > just focus on the code/technical issues which makes Linux to what it is,
> > technically excellent ;-)
> 
> Like it or not, open source development is as much about people
> and their personalitites as it is about technical issues.
> 
> So every timeone someone says to concentrate on the technical
> issues and get past the personalities, they really are missing
> the point, and at best are being naive.
> 
> The Linux kernel has been shaped by overtly emotional discourse and
> personal interaction as it has been by any technical achievement.

Everyone, please read and internalize what Matt had to say.
He is right, the community needs to learn how to review:
   
http://mdzlog.wordpress.com/2008/12/24/constructive-criticism/
