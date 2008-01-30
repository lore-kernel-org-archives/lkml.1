Return-Path: <linux-kernel-owner+w=401wt.eu-S1757371AbYA3MnU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757371AbYA3MnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 07:43:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753952AbYA3MnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 07:43:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:57181 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452AbYA3MnL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 07:43:11 -0500
Date: Wed, 30 Jan 2008 13:43:09 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: "Remy Bohmer" <linux@bohmer.net>
Cc: michael <trimarchi@gandalf.sssup.it>, fabio@gandalf.sssup.it,
       "Andrew Victor" <linux@maxim.org.za>,
       "Chip Coldwell" <coldwell@redhat.com>,
       "Marc Pignat" <marc.pignat@hevs.ch>,
       "David Brownell" <david-b@pacbell.net>, linux-kernel@vger.kernel.org,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH -mm v4 6/9] atmel_serial: Split the interrupt handler
Message-ID: <20080130134309.3806d57a@dhcp-252-066.norway.atmel.com>
In-Reply-To: <3efb10970801300305g693a8371u36011426d3a13b3e@mail.gmail.com>
References: <20080129224316.GA23155@gandalf.sssup.it>
	<479FB2D7.4020804@gandalf.sssup.it>
	<20080130104113.48ec376f@dhcp-252-066.norway.atmel.com>
	<3efb10970801300221h601261edy33cf89dac5abde78@mail.gmail.com>
	<20080130113434.2519f77c@dhcp-252-066.norway.atmel.com>
	<3efb10970801300305g693a8371u36011426d3a13b3e@mail.gmail.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2008 12:05:40 +0100
"Remy Bohmer" <linux@bohmer.net> wrote:

> > > I believe I have to look at the latest set of patches, and try to find
> > > any regressions. Do you have a location somewhere where I can download
> > > the latest versions? Or do I need to dig through LKML to find the
> > > latest... ;-)  
> > They are in -mm. You were Cc'ed I think...  
> 
> Yes, I saw them, but I did not know if there were any updates in the
> mean time, because I had seen some discussions, which confused me a
> bit about the current status of the complete set.

There's been one update, atmel_serial-add-dma-support-fix.patch, which
you were also Cc'ed on.

Haavard
