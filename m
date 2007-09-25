Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbXIYHos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbXIYHos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 03:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbXIYHol
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 03:44:41 -0400
Received: from www.osadl.org ([213.239.205.134]:53017 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751135AbXIYHol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 03:44:41 -0400
Subject: Re: 2.6.23-rc7-mm1
From: Thomas Gleixner <tglx@linutronix.de>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Len Brown <lenb@kernel.org>
In-Reply-To: <64bb37e0709250032j4d2e23c3iccc48fe2e647cbd4@mail.gmail.com>
References: <20070924021716.9bfe7dfb.akpm@linux-foundation.org>
	 <64bb37e0709241207q1c188b35ua485a06776ed4bf2@mail.gmail.com>
	 <20070924123450.f9e54d3d.akpm@linux-foundation.org>
	 <1190665512.4035.247.camel@chaos>
	 <64bb37e0709250032j4d2e23c3iccc48fe2e647cbd4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 25 Sep 2007 09:44:38 +0200
Message-Id: <1190706278.4035.261.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 (2.12.0-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-09-25 at 09:32 +0200, Torsten Kaiser wrote:
> On 9/24/07, Thomas Gleixner <tglx@linutronix.de> wrote:
> > Can your check whether 2.6.23-rc7 +
> > http://tglx.de/projects/hrtimers/2.6.23-rc7/patch-2.6.23-rc7-hrt1.patch
> >
> > works for you ?
> 
> Yes, powers off normally.

Ok, so it's probably some merge artifact in -mm. We'll get this sorted
out once Len has his new tree available.

	tglx


