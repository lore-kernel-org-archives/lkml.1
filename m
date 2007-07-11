Return-Path: <linux-kernel-owner+w=401wt.eu-S1765651AbXGKSsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765651AbXGKSsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 14:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756523AbXGKSsH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 14:48:07 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:49435 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756371AbXGKSsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 14:48:06 -0400
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Jackson <pj@sgi.com>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       menage@google.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070711100331.47ca379d.pj@sgi.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	 <20070710105240.GA20914@linux.vnet.ibm.com>
	 <6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	 <20070710115319.0bdaff34.akpm@linux-foundation.org>
	 <20070711045516.GH2927@linux.vnet.ibm.com>
	 <20070710222942.382fc9ba.akpm@linux-foundation.org>
	 <20070711090423.GA6758@elte.hu> <20070711022352.71604404.pj@sgi.com>
	 <20070711100323.GA23473@linux.vnet.ibm.com>
	 <20070711101958.GA10095@elte.hu>
	 <20070711113953.GB23473@linux.vnet.ibm.com>
	 <20070711044244.c0916fe5.pj@sgi.com> <1184155593.20032.29.camel@twins>
	 <20070711100331.47ca379d.pj@sgi.com>
Content-Type: text/plain
Date: Wed, 11 Jul 2007 20:47:48 +0200
Message-Id: <1184179668.5281.35.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 10:03 -0700, Paul Jackson wrote:
> Peter wrote:
> > I'd very much like to have it, but that is just me.
> 
> Why? [linear combinations of uid, container, pid, pgrp weighting]

Good question, and I really have no other answer than that it seems
usefull and not impossible (or even hard) to implement :-/

I'm not even that interested in using it, it just seems like a nice
idea.


