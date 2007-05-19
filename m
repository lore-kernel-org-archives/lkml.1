Return-Path: <linux-kernel-owner+w=401wt.eu-S1759254AbXESHtn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759254AbXESHtn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 03:49:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755181AbXESHtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 03:49:36 -0400
Received: from mailer.gwdg.de ([134.76.10.26]:52096 "EHLO mailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754437AbXESHtg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 03:49:36 -0400
Date: Sat, 19 May 2007 09:46:51 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Andi Kleen <ak@suse.de>
cc: Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
In-Reply-To: <200705181347.14256.ak@suse.de>
Message-ID: <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr>
References: <464C81B5.8070101@users.sourceforge.net> <464C9D82.60105@redhat.com>
 <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On May 18 2007 13:47, Andi Kleen wrote:
>
>> I do not see such on i386, so why for x86_64?
>
>So that you know that one of your programs crashed. That's a feature.

This feature could be handy for i386 too.


	Jan
-- 
