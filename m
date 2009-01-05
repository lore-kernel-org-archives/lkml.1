Return-Path: <linux-kernel-owner+w=401wt.eu-S1754037AbZAEQXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbZAEQXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 11:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752592AbZAEQX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 11:23:28 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:65178 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753414AbZAEQX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 11:23:27 -0500
Date: Mon, 5 Jan 2009 17:23:12 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>, kernel@avr32linux.org,
       Ben Dooks <ben-linux@fluff.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mmc: atmel-mci: move atmel-mci.h file to include/linux
Message-ID: <20090105172312.22be5a89@hskinnemoen-d830>
In-Reply-To: <20081122194105.348cd5e0@mjolnir.drzeus.cx>
References: <491C0C05.6040301@atmel.com>
	<20081113134818.GA9161@fluff.org.uk>
	<491C3D16.1050501@atmel.com>
	<20081119193631.448ae25e@mjolnir.drzeus.cx>
	<49257B40.8020807@atmel.com>
	<20081122194105.348cd5e0@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> On Thu, 20 Nov 2008 15:59:12 +0100
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
> > Needed to use the atmel-mci driver in an architecture
> > independant maner.
> > 
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> > ---  
> 
> Colour me confused. Shouldn't this go through Haavard?

You're right. I've applied it to the avr32 tree. Thanks!

Haavard
