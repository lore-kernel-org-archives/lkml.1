Return-Path: <linux-kernel-owner+w=401wt.eu-S1759557AbYABUwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759557AbYABUwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 15:52:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754351AbYABUwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 15:52:24 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49002 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYABUwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:52:24 -0500
Date: Wed, 2 Jan 2008 12:52:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Use __u64 in aligned_u64's definition
In-Reply-To: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.1.00.0801021251040.32517@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0801022135500.14900@fbirervta.pbzchgretzou.qr>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2008, Jan Engelhardt wrote:
> 
> please cherrypick 35f2e577e432b28969710bc1fd4d9a4c0875f81b from
> the git://computergmbh.de/linux repository from the "netfilter"
> branch (or use patch below).

Umm. This is missing an explanation of what exactly cares.. Does it 
actually fix some bogus warning, or is it just a cleanup? After -rc1, I 
care. After -rc5, I care a lot.

		Linus
