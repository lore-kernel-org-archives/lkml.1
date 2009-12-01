Return-Path: <linux-kernel-owner+w=401wt.eu-S1754044AbZLAQHw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754044AbZLAQHw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 11:07:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbZLAQHw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 11:07:52 -0500
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:60717 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892AbZLAQHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 11:07:51 -0500
Date: Tue, 1 Dec 2009 10:07:52 -0600 (CST)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David John <davidjon@xenontk.org>
cc: linux-kernel@vger.kernel.org, Jonathan Miles <jon@cybus.co.uk>,
       penberg@cs.helsinki.fi
Subject: Re: OOM kernel behaviour
In-Reply-To: <4B1537CA.7020107@xenontk.org>
Message-ID: <alpine.DEB.2.00.0912011007360.8841@router.home>
References: <4B1402FC.80307@cybus.co.uk> <4B1537CA.7020107@xenontk.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, David John wrote:

> If I start something like Firefox now, the OOM killer is invoked and the
> machine is unusable until it completes. Sometimes the killer is invoked
> multiple times and the only way to make the PC usable again is
> to Ctrl-Alt-Bksp out of X. If RAM is low, why isn't the cache being
> reclaimed?
>
> The issue is sporadic but almost guaranteed if I leave the machine on
> for more than 18 hours. I initially thought some process was leaking
> memory but that seems unlikely.
>
> I can provide more info and do some testing (config etc.) if required.

Post the kernel log output please.

