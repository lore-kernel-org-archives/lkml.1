Return-Path: <linux-kernel-owner+w=401wt.eu-S933027AbXBVL1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933027AbXBVL1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 06:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933034AbXBVL1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 06:27:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:33131 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933027AbXBVL1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 06:27:34 -0500
Subject: Re: [patch] x86: add -freg-struct-return to CFLAGS
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <ak@muc.de>
Cc: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20070222112328.GB10190@muc.de>
References: <45DCF1C5.4030006@goop.org>
	 <1172131463.3531.226.camel@laptopd505.fenrus.org>
	 <45DD4FA0.5030205@goop.org> <20070222083822.GB15068@elte.hu>
	 <20070222112328.GB10190@muc.de>
Content-Type: text/plain
Organization: Intel International BV
Date: Thu, 22 Feb 2007 12:27:19 +0100
Message-Id: <1172143639.3531.247.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I guess people maintaining external Makefiles without Kbuild 
> are in for a nasty surprise again though.

that 1) shouldn't be needed at all for 2.6 and 2) is fragile as heck no
matter, I don't think anyone still is doing that... I sure hope that if
anyone still does it that they have no users at all, for the sake of the
users :)


-- 
if you want to mail me at work (you don't), use arjan (at) linux.intel.com
Test the interaction between Linux and your BIOS via http://www.linuxfirmwarekit.org

