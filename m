Return-Path: <linux-kernel-owner+w=401wt.eu-S1758699AbZIOVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699AbZIOVv6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 17:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751117AbZIOVv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 17:51:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:34218 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZIOVv4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 17:51:56 -0400
Subject: Re: [git pull] Please pull powerpc.git next branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, FUJITA Tomonori <tomof@acm.org>,
       Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
In-Reply-To: <alpine.LFD.2.01.0909150943580.4950@localhost.localdomain>
References: <1252653473.8566.98.camel@pasglop>
	 <1252999835.8375.205.camel@pasglop>
	 <alpine.LFD.2.01.0909150943580.4950@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 07:51:28 +1000
Message-Id: <1253051488.8375.233.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 09:53 -0700, Linus Torvalds wrote:
> It got a conflict with the AGP merge, but I fixed it up in what _seemed_ 
> to be the obvious manner. But somebody should check out the resulting
> drivers/char/agp/uninorth-agp.c file.

Thanks. 

Michel, can you dbl check it ?

Cheers,
Ben.


