Return-Path: <linux-kernel-owner+w=401wt.eu-S933616AbXCOUQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933616AbXCOUQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933790AbXCOUQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:16:12 -0400
Received: from gw.goop.org ([64.81.55.164]:59413 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933616AbXCOUQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:16:08 -0400
Message-ID: <45F9A980.3090004@goop.org>
Date: Thu, 15 Mar 2007 13:16:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, eranian@hpl.hp.com, rdunlap@xenotime.net,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
References: <45F5FA97.8070705@goop.org>	<20070315110805.262e1fa3.akpm@linux-foundation.org>	<45F99B6F.9000604@goop.org>	<20070315113301.5150a415.akpm@linux-foundation.org>	<45F9A0E1.2080900@goop.org> <p73wt1i6xco.fsf@bingen.suse.de>
In-Reply-To: <p73wt1i6xco.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> I already got that patch, but haven't synced it out yet.

My patch?  I just rebased it against Jan's patch
(x86_64-mm-consolidate-smp_send_stop.patch) which was causing the
conflict.  Do you want that version instead?


    J
