Return-Path: <linux-kernel-owner+w=401wt.eu-S1762892AbXGKRDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762892AbXGKRDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 13:03:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbXGKRDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 13:03:34 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35497 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbXGKRDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 13:03:34 -0400
Date: Wed, 11 Jul 2007 10:03:31 -0700
From: Paul Jackson <pj@sgi.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: vatsa@linux.vnet.ibm.com, mingo@elte.hu, containers@lists.osdl.org,
       menage@google.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070711100331.47ca379d.pj@sgi.com>
In-Reply-To: <1184155593.20032.29.camel@twins>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710105240.GA20914@linux.vnet.ibm.com>
	<6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	<20070710115319.0bdaff34.akpm@linux-foundation.org>
	<20070711045516.GH2927@linux.vnet.ibm.com>
	<20070710222942.382fc9ba.akpm@linux-foundation.org>
	<20070711090423.GA6758@elte.hu>
	<20070711022352.71604404.pj@sgi.com>
	<20070711100323.GA23473@linux.vnet.ibm.com>
	<20070711101958.GA10095@elte.hu>
	<20070711113953.GB23473@linux.vnet.ibm.com>
	<20070711044244.c0916fe5.pj@sgi.com>
	<1184155593.20032.29.camel@twins>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Peter wrote:
> I'd very much like to have it, but that is just me.

Why? [linear combinations of uid, container, pid, pgrp weighting]

You provide some implementation details and complications, but no
motivation that I noticed.

Well ... a little motivation ... "just me", which would go a long
way of your first name was Linus.  For the rest of us ... ;).

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
