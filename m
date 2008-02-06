Return-Path: <linux-kernel-owner+w=401wt.eu-S1760782AbYBFI4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760782AbYBFI4R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758872AbYBFI4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:56:07 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:2184 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758719AbYBFI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:56:06 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Subject: Re: dma error on boot with cf card
Date: Wed, 6 Feb 2008 09:54:53 +0100
User-Agent: KMail/1.9.6
References: <200802051852.29592.donner@dbd-breitband.de> <20080205185628.GF26259@csclub.uwaterloo.ca>
In-Reply-To: <20080205185628.GF26259@csclub.uwaterloo.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802060954.53802.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 February 2008, you wrote:
> On Tue, Feb 05, 2008 at 06:52:29PM +0100, Marc Donner wrote:
> > hi,
> >
> > i have a problem using a cf card with an ide adapter.
> > using debian kernel 2.6.18-5
> >
>
> Adapter doesn't support DMA, but controller and CF cards do.  To fix,
> tell the system NOT to use dma on that interface.

and how do i disable dma? it is the installer image, and no hdparm is 
availible. and the ide=nodma boot parameter seems not to work. 

Marc
