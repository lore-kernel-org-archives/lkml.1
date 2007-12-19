Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbXLSLlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbXLSLlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 06:41:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751537AbXLSLlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 06:41:04 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:53440 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752442AbXLSLlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 06:41:03 -0500
Date: Wed, 19 Dec 2007 12:40:08 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Chip Coldwell <coldwell@redhat.com>
Cc: linux@arm.linux.org.uk, kernel@avr32linux.org,
       linux-kernel@vger.kernel.org, Andrew Victor <linux@maxim.org.za>,
       Remy Bohmer <linux@bohmer.net>, linux-arm-kernel@lists.arm.linux.org.uk,
       git@vger.kernel.org
Subject: Re: [PATCH 4/5] atmel_serial: Split the interrupt handler
Message-ID: <20071219124008.4945e592@dhcp-252-066.norway.atmel.com>
In-Reply-To: <alpine.LFD.0.9999.0712181318300.27475@localhost.localdomain>
References: <1197997575-13292-1-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-2-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-3-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-4-git-send-email-hskinnemoen@atmel.com>
	<1197997575-13292-5-git-send-email-hskinnemoen@atmel.com>
	<20071218181019.2af46418@dhcp-252-066.norway.atmel.com>
	<alpine.LFD.0.9999.0712181318300.27475@localhost.localdomain>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2007 13:19:39 -0500 (EST)
Chip Coldwell <coldwell@redhat.com> wrote:

> > On Tue, 18 Dec 2007 18:06:14 +0100
> > Haavard Skinnemoen <hskinnemoen@atmel.com> wrote:
> >   
> > > From: Remy Bohmer <hskinnemoen@atmel.com>  
> > 
> > Heh. That's obviously wrong. Wonder what happened there?
> > 
> > Looks like Chip's address got mangled too.  
> 
> You can find me at <coldwell@gmail.com> or <coldwell@redhat.com> these
> days, although <coldwell@frank.harvard.edu> still works for the time
> being.

Thanks. I'll update the broken commits.

Btw, the funny thing is that, looking at my shell history, I think I
actually did the right thing when committing your patches:

git commit -s --author 'Remy Bohmer <linux@bohmer.net>'
git commit -s --author 'Chip Coldwell <coldwell@frank.harvard.edu>'

But for some reason only your names stuck, not your e-mail addresses...

Haavard
