Return-Path: <linux-kernel-owner+w=401wt.eu-S1751308AbXCOTQB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751308AbXCOTQB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:16:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751600AbXCOTQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:16:01 -0400
Received: from gw.goop.org ([64.81.55.164]:45226 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878AbXCOTQA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:16:00 -0400
Message-ID: <45F99B6F.9000604@goop.org>
Date: Thu, 15 Mar 2007 12:15:59 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: ak@suse.de, linux-kernel@vger.kernel.org, mingo@elte.hu,
       eranian@hpl.hp.com, rdunlap@xenotime.net
Subject: Re: [PATCH] i386: Simplify smp_call_function*() by using common implementation
References: <45F5FA97.8070705@goop.org> <20070315110805.262e1fa3.akpm@linux-foundation.org>
In-Reply-To: <20070315110805.262e1fa3.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Hopeless, sorry.   It's probably time to start thinking about raising x86
> patches against the x86 tree (at least).
>   

You mean this conflicts heavily with your and/or andi's tree?

    J
