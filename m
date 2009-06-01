Return-Path: <linux-kernel-owner+w=401wt.eu-S1757223AbZFAJ5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757223AbZFAJ5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756009AbZFAJ5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:57:12 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36008 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755682AbZFAJ5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:57:12 -0400
Date: Mon, 1 Jun 2009 10:58:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Michael Buesch <mb@bu3sch.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: parport_pc: Fix subscription bugs
Message-ID: <20090601105819.65b92632@lxorguk.ukuu.org.uk>
In-Reply-To: <200906011127.03296.mb@bu3sch.de>
References: <200906011100.34086.mb@bu3sch.de>
	<20090601101440.203c000a@lxorguk.ukuu.org.uk>
	<200906011127.03296.mb@bu3sch.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yeah well. If I did not fix the style violations, somebody else would have complained
> already that when somebody touches some code he should also fix the style issues. ;)
> Happened to be several times, so I chose to fix them here...

Yes Andrew likes code to become horrible and inconsistent it seems ;)

I'll post a follow up to your patch to whack the whole thing into style
and switch those loops.
