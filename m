Return-Path: <linux-kernel-owner+w=401wt.eu-S1754361AbXLRKfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754361AbXLRKfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2007 05:35:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXLRKfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Dec 2007 05:35:06 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53841 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753288AbXLRKfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2007 05:35:05 -0500
Date: Tue, 18 Dec 2007 11:33:37 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] atmel_serial: Clean up the code
Message-ID: <20071218113337.061a8e59@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970712180214g374749cbh940958e1eff7185c@mail.gmail.com>
References: <1197971591-23890-1-git-send-email-hskinnemoen@atmel.com>
	<3efb10970712180214g374749cbh940958e1eff7185c@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 11:14:42 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> Hello Haavard,
> 
> > Please note that I'm not trying to steal the show here -- I just want
> 
> That did not even come to my mind at all...
> I am happy with everything that helps making this driver better.

Good :)

> What shall we do first from here, splitup of the interrupt handler? Or
> DMA patch?

I currently have the patches applied in the order you sent them, with my
stuff wedged in between (thanks to git-rebase --interactive.) So I
think it makes sense to do the interrupt handler splitup first, even
though I personally care more about the DMA patch.

Haavard
