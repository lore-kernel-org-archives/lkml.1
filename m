Return-Path: <linux-kernel-owner+w=401wt.eu-S1755735AbYH0TMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735AbYH0TMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 15:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbYH0TM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 15:12:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42632 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751053AbYH0TM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 15:12:29 -0400
Date: Wed, 27 Aug 2008 12:11:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: nicolas.ferre@atmel.com, david-b@pacbell.net, linux-kernel@vger.kernel.org,
       linux@maxim.org.za, rmk@arm.linux.org.uk
Subject: Re: [patch 2.6.27-rc3] at91_mci: don't use coherent dma buffers
Message-Id: <20080827121126.9676a4eb.akpm@linux-foundation.org>
In-Reply-To: <20080827210105.43d5aed2@mjolnir.drzeus.cx>
References: <200808181607.21516.david-b@pacbell.net>
	<48AE6D50.4030609@atmel.com>
	<48AE7B7E.1010503@atmel.com>
	<20080827210105.43d5aed2@mjolnir.drzeus.cx>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2008 21:01:05 +0200
Pierre Ossman <drzeus-mmc@drzeus.cx> wrote:

> On Fri, 22 Aug 2008 10:40:30 +0200
> Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> 
> > >>
> > >> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > > 
> > > ...
> > 
> > Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> 
> I have nothing else in my queue, so Andrew, as I suspect you have other
> things going to Linus, if you could please include this one as well. :)

No probs, thanks.

