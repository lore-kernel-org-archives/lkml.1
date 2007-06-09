Return-Path: <linux-kernel-owner+w=401wt.eu-S1761059AbXFIUl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761059AbXFIUl2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 16:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761067AbXFIUlO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 16:41:14 -0400
Received: from khc.piap.pl ([195.187.100.11]:38628 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760195AbXFIUlN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 16:41:13 -0400
To: "John Stoffel" <john@stoffel.org>
Cc: Jeff Garzik <jeff@garzik.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel-rng: Undo mess made by an 80 column extremist
References: <20070607162251.5f291325@the-village.bc.nu>
	<m3wsyfzcpt.fsf@maximus.localdomain>
	<18024.46233.432086.424311@stoffel.org>
	<20070608014719.GC23290@havoc.gtf.org>
	<18024.46902.682920.924521@stoffel.org>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Sat, 09 Jun 2007 22:41:11 +0200
In-Reply-To: <18024.46902.682920.924521@stoffel.org> (John Stoffel's message of "Thu, 7 Jun 2007 21:56:06 -0400")
Message-ID: <m3bqfosvx4.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"John Stoffel" <john@stoffel.org> writes:

> Thinking about it more, I wonder if Krysztof is bitching more about
> the tab width of 8 characters?   I know that it ticks me off,
> indenting by two spaces is plenty for me to follow the flow, along
> with Emacs and braces closure indication.

Well, 8 might be too long but I wouldn't be able to read the code
with 2-chars tabs. Even on a large wall display.

4 chars, maybe, but I'm not sure. 8 chars is great except that the
lines are too short.

Obviously it's the space taken by indentation, the "real" line
length of ~ 70 chars (such as in this msg) is ok.
-- 
Krzysztof Halasa
