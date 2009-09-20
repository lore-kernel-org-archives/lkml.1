Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbZITSzC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbZITSzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 14:55:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbZITSy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 14:54:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755650AbZITSy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 14:54:59 -0400
Date: Sun, 20 Sep 2009 20:50:38 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: lkml@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Russell King <linux@arm.linux.org.uk>, Pavel Machek <pavel@ucw.cz>,
       linux-arm@vger.kernel.org, linux-arm@lists.infradead.org
Subject: Re: [PATCH] [TRIVIAL] Changes to IRQs.
In-Reply-To: <alpine.LNX.2.00.0909202042300.17028@wotan.suse.de>
Message-ID: <alpine.LNX.2.00.0909202045080.17028@wotan.suse.de>
References: <m34oqx4s0e.fsf@intrepid.localdomain> <alpine.LNX.2.00.0909202042300.17028@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Sep 2009, Jiri Kosina wrote:

> This doesn't really qualify for trivial queue, adding ARM addressess to CC 
> (I hope I got them right after the latest flame :P)

Hmm, apparently I did not.


	<linux-arm-kernel@lists.arm.linux.org.uk>: host
	    lists.arm.linux.org.uk[78.32.30.220] said: 550 Please direct your 
	    message to the new mailing lists on lists.infradead.org (in reply to 
	    RCPT TO command)


Could someone please update MAINTAINERS to reflect reality? I am 
apparently not smart enough to keep track of the current situation with 
the ARM mailinglists. I thought that final decision was 
linux-arm@vger.kernel.org. MAINTAINERS lists 
linux-arm-kernel@lists.arm.linux.org.uk, but the bounce suggests to use 
lists.infradead.org ... 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

