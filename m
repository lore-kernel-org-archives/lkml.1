Return-Path: <linux-kernel-owner+w=401wt.eu-S967179AbXFHCMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967179AbXFHCMR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966321AbXFHCMF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:12:05 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:32821 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966316AbXFHCME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:12:04 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18024.47852.272454.21519@stoffel.org>
Date: Thu, 7 Jun 2007 22:11:56 -0400
From: "John Stoffel" <john@stoffel.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: John Stoffel <john@stoffel.org>, Krzysztof Halasa <khc@pm.waw.pl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, akpm@osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
In-Reply-To: <20070608020730.GD23290@havoc.gtf.org>
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<18024.46233.432086.424311@stoffel.org>
	<20070608014719.GC23290@havoc.gtf.org>
	<18024.46902.682920.924521@stoffel.org>
	<20070608020730.GD23290@havoc.gtf.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Jeff> On Thu, Jun 07, 2007 at 09:56:06PM -0400, John Stoffel wrote:
>> Thinking about it more, I wonder if Krysztof is bitching more about
>> the tab width of 8 characters?   I know that it ticks me off,

Jeff> Even if he is, _that_ is definitely not getting changed.

Oh sure... I know that part is written in stone.  

Jeff> That was the very first item Linus wrote in
Jeff> Documentation/CodingStyle, and for good reasons.

I could argue that 4 spaces would be a better level, but it's a
personal preference and not worth the battle.  

Jeff> If code starts creeping way right due to indentation levels,
Jeff> create a new function.

Sure... compilers are good, us humans haven't gotten much better, make
it easier on us and harder on the computer.   

John
