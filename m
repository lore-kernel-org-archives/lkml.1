Return-Path: <linux-kernel-owner+w=401wt.eu-S1754033AbZGTWZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033AbZGTWZJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 18:25:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZGTWZJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 18:25:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753299AbZGTWZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 18:25:08 -0400
Date: Mon, 20 Jul 2009 15:24:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, nicolas.ferre@atmel.com,
       avictor.za@gmail.com, patrice.vilchez@atmel.com,
       linux-kernel@vger.kernel.org, hong.xu@atmel.com
Subject: Re: [PATCH 5/5] at91/atmel_lcdfb: add at91sam9g10 support to atmel
 LCD driver
Message-Id: <20090720152427.b63bb3bd.akpm@linux-foundation.org>
In-Reply-To: <4A51D2D5.2030707@atmel.com>
References: <1245341772-1689-1-git-send-email-nicolas.ferre@atmel.com>
	<1245341772-1689-6-git-send-email-nicolas.ferre@atmel.com>
	<4A51D2D5.2030707@atmel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 06 Jul 2009 12:32:53 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Hi,
> 
> Nicolas Ferre :
> > From: Hong Xu <hong.xu@atmel.com>
> > 
> > Modify atmel LCD driver: atmel_lcdfb for at91sam9g10.  This add a clock
> > management equivalent to at91sam9261.
> 
> Can we consider an inclusion in linux-fbdev ?

The patch looks OK to me.

> > Signed-off-by: Hong Xu <hong.xu@atmel.com>
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> 
> Andrew Victor added his:
> Acked-by: Andrew Victor <linux@maxim.org.za>
> 
> > ---
> >  drivers/video/Kconfig           |    4 ++--
> >  drivers/video/atmel_lcdfb.c     |    6 ++++--
> >  drivers/video/backlight/Kconfig |    2 +-
> >  3 files changed, 7 insertions(+), 5 deletions(-)

Please merge it via an ARM tree?
