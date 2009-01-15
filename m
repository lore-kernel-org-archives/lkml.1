Return-Path: <linux-kernel-owner+w=401wt.eu-S1765677AbZAOOgZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765677AbZAOOgZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 09:36:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760448AbZAOOgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 09:36:05 -0500
Received: from aeryn.fluff.org.uk ([87.194.8.8]:48702 "EHLO
	kira.home.fluff.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765436AbZAOOgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 09:36:04 -0500
Date: Thu, 15 Jan 2009 14:35:35 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Liu Dave <DaveLiu@freescale.com>, Pierre Ossman <drzeus-mmc@drzeus.cx>,
       linuxppc-dev@ozlabs.org, Lai Kon-LKL001 <Konjin.Lai@freescale.com>,
       linux-kernel@vger.kernel.org, Xie Xiaobo-R63061 <X.Xie@freescale.com>,
       "D'Abbraccio Joe-LJD015" <Joe.D'abbraccio@freescale.com>
Subject: Re: [PATCH] mmc: Add driver for Freescale eSDHC controllers
Message-ID: <20090115143535.GT12431@fluff.org.uk>
References: <20090114194631.GA25978@oksana.dev.rtsoft.ru> <D7CCA83BB0796C49BC0BB53B6AB1208907ABDB@zch01exm21.fsl.freescale.net> <20090114235605.GA13531@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090114235605.GA13531@oksana.dev.rtsoft.ru>
X-Disclaimer: These are my own opinions, so there!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2009 at 02:56:05AM +0300, Anton Vorontsov wrote:
> On Thu, Jan 15, 2009 at 07:37:00AM +0800, Liu Dave wrote:
> > > This patch adds support for the Freescale Enhanced Secure Digital
> > > Host Controller Interface as found in some Freescale PowerPC
> > > microprocessors (e.g. MPC837x SOCs).
> > 
> > The Freescale ESDHC controller is basically compatible with the
> > standard SDHC controller. but the eshdc expand some bits.
> > 
> > The esdhc.c is much like the orignal sdhci.c.
> > it is possible to merge them.
> 
> Ah. I wonder why Freescale just didn't write some patches for sdhci,
> but copied the code instead...

For the same reasons earthmen like tea.

-- 
Ben (ben@fluff.org, http://www.fluff.org/)

  'a smiley only costs 4 bytes'
