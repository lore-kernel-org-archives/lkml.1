Return-Path: <linux-kernel-owner+w=401wt.eu-S1753655AbXJAKbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbXJAKbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 06:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751447AbXJAKbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 06:31:10 -0400
Received: from usermail.globalproof.net ([194.146.153.18]:41987 "EHLO
	usermail.globalproof.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbXJAKbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 06:31:09 -0400
From: "Denys" <nuclearcat@nuclearcat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 -> 2.6.22 & 2.6.23-rc8 performance regression
Date: Mon, 1 Oct 2007 13:30:52 +0300
Message-Id: <20071001103026.M59805@nuclearcat.com>
In-Reply-To: <p73myv36tmz.fsf@bingen.suse.de>
References: <20070930144443.M52139@visp.net.lb> <46FFE17C.9020202@cosmosbay.com> <200709301425.37564.nickpiggin@yahoo.com.au> <20070930220452.M25621@nuclearcat.com> <p73myv36tmz.fsf@bingen.suse.de>
X-Mailer: OpenWebMail 2.52 20060502
X-OriginatingIP: 194.146.154.161 (denys@visp.net.lb)
MIME-Version: 1.0
Content-Type: text/plain;
	charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Already i did, and it didn't show real failure point.

On 01 Oct 2007 12:01:24 +0200, Andi Kleen wrote
> "Denys" <nuclearcat@nuclearcat.com> writes:
> 
> > by mistake i will miss a point (it can detect bug easily, IF softirq in 
> > mpstat 1 will jump up to 30+%. On 2.6.21 it is always staying +-10%, on 
> > "buggy" version it jumps up to 100%. Now cause less load at night up to 30-
> > 50%, so on hardware it is not very noticeable (thats why maybe not much 
> > feedbacks), i am trying to utilise hardware maximum as possible - so i feel 
> > regressions much more.
> 
> You could use oprofile to find where the CPU time is spent
> 
> -Andi


--
Denys Fedoryshchenko
Technical Manager
Virtual ISP S.A.L.

