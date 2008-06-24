Return-Path: <linux-kernel-owner+w=401wt.eu-S1758482AbYFXJaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758482AbYFXJaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 05:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752453AbYFXJao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 05:30:44 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42733 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750751AbYFXJan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 05:30:43 -0400
Date: Tue, 24 Jun 2008 10:12:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: David Brownell <david-b@pacbell.net>
Cc: Robert Hancock <hancockr@shaw.ca>, benh@kernel.crashing.org,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       hpa@zytor.com
Subject: Re: [patch] x86 supports NO_IRQ convention
Message-ID: <20080624101244.70d7e54c@lxorguk.ukuu.org.uk>
In-Reply-To: <200806232339.25926.david-b@pacbell.net>
References: <fa.mcHAIQmpGZB1Vrm7ZD4/q9eo08Y@ifi.uio.no>
	<fa.EDfpY1oxab2UaliWrUY0jyr5T1k@ifi.uio.no>
	<486059F9.6060901@shaw.ca>
	<200806232339.25926.david-b@pacbell.net>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.10; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Leaving the question then of what should happen to
> the existing NO_IRQ code ... none of the declarations
> seems to have a comment "deprecated, don't use this"
> and most of the defined values are nonzero.

Send patches to the arch maintainers in question.

Alan
