Return-Path: <linux-kernel-owner+w=401wt.eu-S933212AbXCOTjq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933212AbXCOTjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:39:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933211AbXCOTjq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:39:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:37963 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933212AbXCOTjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:39:45 -0400
Date: Thu, 15 Mar 2007 11:33:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       eranian@hpl.hp.com, rdunlap@xenotime.net
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common
 implementation
Message-Id: <20070315113301.5150a415.akpm@linux-foundation.org>
In-Reply-To: <45F99B6F.9000604@goop.org>
References: <45F5FA97.8070705@goop.org>
	<20070315110805.262e1fa3.akpm@linux-foundation.org>
	<45F99B6F.9000604@goop.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Mar 2007 12:15:59 -0700 Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Andrew Morton wrote:
> > Hopeless, sorry.   It's probably time to start thinking about raising x86
> > patches against the x86 tree (at least).
> >   
> 
> You mean this conflicts heavily with your and/or andi's tree?
> 

Yup.  There is a huge and growing amount of outstanding x86 work.  As
always.  Developing against mainline is very optimistic.
