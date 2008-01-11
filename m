Return-Path: <linux-kernel-owner+w=401wt.eu-S1761253AbYAKJeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761253AbYAKJeW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 04:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbYAKJeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 04:34:07 -0500
Received: from brick.kernel.dk ([87.55.233.238]:26517 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758250AbYAKJeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:34:05 -0500
Date: Fri, 11 Jan 2008 10:34:01 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Dillow <dillowda@ornl.gov>, Guillaume Chazarain <guichaz@yahoo.fr>,
       linux-kernel@vger.kernel.org, linux-btrace@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de
Subject: Re: CONFIG_NO_HZ breaks blktrace timestamps
Message-ID: <20080111093401.GP6258@kernel.dk>
References: <1199918912.8388.13.camel@lap75545.ornl.gov> <1199996752.9159.46.camel@lap75545.ornl.gov> <20080110234438.4826f658@inria.fr> <1200020661.5099.3.camel@obelisk.thedillows.org> <20080111090723.GI6258@kernel.dk> <20080111092334.GA8143@elte.hu> <20080111092925.GB8143@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080111092925.GB8143@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11 2008, Ingo Molnar wrote:
> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > Thanks for reporting this. Guillaume, did you write this patch? We 
> > > need to get it into 2.6.24-rc7 asap. Let me know if I should take 
> > > care of that, or if it's already queued up elsewhere.
> > 
> > they are from the scheduler git tree (except the first debug patch), 
> > but queued up for v2.6.25 at the moment.
> 
> some of them are not - Guillaume has not sent them. I'll sort it out.

Thanks Ingo!

-- 
Jens Axboe

