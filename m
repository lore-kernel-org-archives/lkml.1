Return-Path: <linux-kernel-owner+w=401wt.eu-S1753555AbZIOWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555AbZIOWrj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbZIOWrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 18:47:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:59785 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbZIOWre (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 18:47:34 -0400
From: Krzysztof Halasa <khc@pm.waw.pl>
To: Steve Chen <schen@mvista.com>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Jamie Lokier <jamie@shareable.org>, linux-kernel@vger.kernel.org,
       Marek Vasut <marek.vasut@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
References: <1252875960-21512-1-git-send-email-felipe.contreras@gmail.com>
	<20090915103739.GA19519@elf.ucw.cz>
	<1253017761.3273.117.camel@linux-1lbu>
	<200909151541.08852.marek.vasut@gmail.com>
	<1253032210.3273.128.camel@linux-1lbu>
	<94a0d4530909151158y489a96e3x63ff932c713822b0@mail.gmail.com>
	<1253043875.3273.131.camel@linux-1lbu>
	<m3k4zzdimy.fsf@intrepid.localdomain>
	<1253053609.3273.139.camel@linux-1lbu>
Date: Wed, 16 Sep 2009 00:47:34 +0200
In-Reply-To: <1253053609.3273.139.camel@linux-1lbu> (Steve Chen's message of
	"Tue, 15 Sep 2009 17:26:49 -0500")
Message-ID: <m33a6nddvd.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steve Chen <schen@mvista.com> writes:

> If I know for sure that these are the processors that need that block of
> code, your suggestion makes perfect sense.  Unfortunately, I don't know.

Then I wouldn't write "Accurate delays". "Different", maybe.
"Accurate", we don't know.

> My primary goals are
>
> 1.  Put a stop to this thread (so far I have failed miserably)
> 2.  Document that block of code.
> 3.  If it makes someone's life easier.. it would be a bonus.

Uncertain comments don't make life easier. Just write what's certain,
or nothing if nothing is.
-- 
Krzysztof Halasa
