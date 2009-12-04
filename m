Return-Path: <linux-kernel-owner+w=401wt.eu-S1756244AbZLDMRR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbZLDMRR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 07:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755724AbZLDMRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 07:17:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:34186 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754974AbZLDMRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 07:17:15 -0500
Subject: Re: -next: Nov 12 - kernel BUG at kernel/sched.c:7359!
From: Peter Zijlstra <peterz@infradead.org>
To: Sachin Sant <sachinp@in.ibm.com>
Cc: ego@in.ibm.com, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, maxk <maxk@qualcomm.com>
In-Reply-To: <4B18FB2E.1070200@in.ibm.com>
References: <20091112195101.63263490.sfr@canb.auug.org.au>
	 <4AFBF73B.5040500@in.ibm.com> <1258027820.4039.129.camel@laptop>
	 <4AFBFE3D.80507@in.ibm.com> <1258028831.4039.152.camel@laptop>
	 <1258045831.4039.736.camel@laptop>  <20091113095801.GA29977@in.ibm.com>
	 <1258107368.4039.1149.camel@laptop> <1258108281.22655.5.camel@laptop>
	 <4B0A5BA7.8020604@in.ibm.com> <1259156575.4027.514.camel@laptop>
	 <4B18FB2E.1070200@in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:16:50 +0100
Message-ID: <1259929010.17907.178.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 17:36 +0530, Sachin Sant wrote:
> 
> Ping on this patch. Still missing from linux-next.

I know, it got stuck in my queue too long, but I handed it to Ingo
yesterday, should appear in tip soonish.

