Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbYAKQpK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbYAKQpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 11:45:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760053AbYAKQo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 11:44:57 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:37841 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754090AbYAKQo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 11:44:56 -0500
Date: Fri, 11 Jan 2008 17:44:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: David Dillow <dillowda@ornl.gov>
Cc: Jens Axboe <jens.axboe@oracle.com>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: [patch] block: fix blktrace timestamps
Message-ID: <20080111164430.GA18862@elte.hu>
References: <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092513.GO6258@kernel.dk> <20080111094205.GE8143@elte.hu> <20080111095654.GR6258@kernel.dk> <20080111102953.GA27223@elte.hu> <1200065783.7480.2.camel@lap75545.ornl.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1200065783.7480.2.camel@lap75545.ornl.gov>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Dillow <dillowda@ornl.gov> wrote:

> On Fri, 2008-01-11 at 11:29 +0100, Ingo Molnar wrote:
> > (David, could you try the patch further below - does it fix bkltrace 
> > timestamps too?)
> 
> Jens already got back to you, but I can confirm it works here as well.

great, thanks for testing it. (i'm not sure Jens saw the same issues as 
you, so your test was useful too.)

	Ingo
