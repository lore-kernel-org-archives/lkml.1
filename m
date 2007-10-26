Return-Path: <linux-kernel-owner+w=401wt.eu-S1755099AbXJZQZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099AbXJZQZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 12:25:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbXJZQZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 12:25:03 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:51822 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752616AbXJZQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 12:25:00 -0400
Date: Fri, 26 Oct 2007 12:24:48 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Blaisorblade <blaisorblade@yahoo.it>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PROBLEM] UM does not compile on i386
Message-ID: <20071026162448.GA7770@c2.user-mode-linux.org>
References: <84144f020710260558o16238b54y89936bcfc18a0e6c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020710260558o16238b54y89936bcfc18a0e6c@mail.gmail.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2007 at 03:58:04PM +0300, Pekka Enberg wrote:
> The current Linus' git does not compile on i386 for UM defconfig:

You need this patch:

	http://marc.info/?l=linux-kernel&m=119332492222601&q=raw

				Jeff

-- 
Work email - jdike at linux dot intel dot com
