Return-Path: <linux-kernel-owner+w=401wt.eu-S933291AbXC0XHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933291AbXC0XHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 19:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933307AbXC0XHn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 19:07:43 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57337 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933291AbXC0XHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 19:07:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: 2.6.21-rc5: known regressions with patches
Date: Wed, 28 Mar 2007 01:10:44 +0200
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>, tigran@aivazian.fsnet.co.uk
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org> <20070327230024.GJ16477@stusta.de>
In-Reply-To: <20070327230024.GJ16477@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703280110.45403.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 28 March 2007 01:00, Adrian Bunk wrote:
> This email lists some known regressions in Linus' tree compared to 2.6.20
> with patches available.
> 
> If you find your name in the Cc header, you are either submitter of one
> of the bugs, maintainer of an affectected subsystem or driver, a patch
> of you caused a breakage or I'm considering you in any other way
> possibly involved with one or more of these issues.
> 
> Due to the huge amount of recipients, please trim the Cc when answering.
 
> Subject    : suspend to disk hangs  (microcode driver)
> References : http://lkml.org/lkml/2007/3/16/126
> Submitter  : Maxim Levitsky <maximlevitsky@gmail.com>
> Caused-By  : Rafael J. Wysocki <rjw@sisk.pl>
>              commit e3c7db621bed4afb8e231cb005057f2feb5db557
>              commit ed746e3b18f4df18afa3763155972c5835f284c5
>              commit 259130526c267550bc365d3015917d90667732f1
> Handled-By : Rafael J. Wysocki <rjw@sisk.pl>
> Patch      : http://lkml.org/lkml/2007/3/23/179
> Status     : patch available

Updated patch is available at http://lkml.org/lkml/2007/3/25/71

Greetings,
Rafael
