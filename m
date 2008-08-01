Return-Path: <linux-kernel-owner+w=401wt.eu-S1754247AbYHAFC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247AbYHAFC3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 01:02:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYHAFCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 01:02:22 -0400
Received: from 1wt.eu ([62.212.114.60]:2342 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751606AbYHAFCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 01:02:21 -0400
Date: Fri, 1 Aug 2008 07:02:14 +0200
From: Willy Tarreau <w@1wt.eu>
To: ml@mareichelt.de, linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Subject: Re: Linux 2.6.25.13
Message-ID: <20080801050214.GE615@1wt.eu>
References: <20080728180740.GA28669@kroah.com> <20080731232235.GD10067@tatooine.rebelbase.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080731232235.GD10067@tatooine.rebelbase.local>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[ please keep people in CC: ]

On Fri, Aug 01, 2008 at 01:22:35AM +0200, markus reichelt wrote:
> * Greg KH <gregkh@suse.de> wrote:
> 
> > I'll also be replying to this message with a copy of the patch
> > between 2.6.25.12 and 2.6.25.13
> 
> Given that the official patches are signed, how about signing such
> mails as well?

It would serve nothing and add more things to take care of on maintainers
side. Eventhough some parts are scripted, releasing a kernel is a tough
work with a long checklist. I'd prefer Greg to continue to release often
when he has good fixes than knowing he wastes his time ensuring everything
is ready to match everyone's specific expectations.

> I actually prefer such small diffs in comparison to keeping a copy of
> 2.6.X and applying the latest patch to it in order to update via a
> signed patch. (it's a policy thing.)

I tend to agree with your policy, but then you can simply download the
signed incremental diffs there :
   http://www.kernel.org/pub/linux/kernel/v2.6/incr/

Regards,
Willy

