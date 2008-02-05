Return-Path: <linux-kernel-owner+w=401wt.eu-S1757997AbYBELMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997AbYBELMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 06:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbYBELLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 06:11:48 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:54474 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756691AbYBELLr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 06:11:47 -0500
Date: Tue, 5 Feb 2008 12:11:26 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Re: [PATCH] kbuild: Fix instrumentation removal breakage on avr32
Message-ID: <20080205121126.7ccdce8f@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080204194626.GA16664@uranus.ravnborg.org>
References: <20080203211042.GF2648@uranus.ravnborg.org>
	<20080204124448.3633e937@dhcp-252-066.norway.atmel.com>
	<20080204194626.GA16664@uranus.ravnborg.org>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2008 20:46:26 +0100
Sam Ravnborg <sam@ravnborg.org> wrote:

> Sorry for not catching this.
> I just blow away my git tree at kernel.org to avoid getting it
> merged with the bug but Linus was too quick for me so he already
> merged kbuild.git and applied this patch afterwards.

Ok, the result looks good. Thanks.

Bisecting on avr32 will be a nightmare though, but not only because of
this patch...

Haavard
