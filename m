Return-Path: <linux-kernel-owner+w=401wt.eu-S1756131AbYBDQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbYBDQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 11:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753230AbYBDQZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 11:25:20 -0500
Received: from mail.dbd-breitband.de ([217.188.211.21]:2181 "EHLO
	dbd-mpx01.dbd-breitband.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750979AbYBDQZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 11:25:19 -0500
From: Marc Donner <donner@dbd-breitband.de>
Organization: DBD DeutscheBreitbandDienste
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: What's about WiMAX?
User-Agent: KMail/1.9.6
References: <200802041600.31677.donner@dbd-breitband.de> <20080204155935.GD3446@tuxdriver.com>
In-Reply-To: <20080204155935.GD3446@tuxdriver.com>
MIME-Version: 1.0
Content-Disposition: inline
Date: Mon, 4 Feb 2008 17:24:22 +0100
Cc: kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200802041724.22486.donner@dbd-breitband.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 February 2008, you wrote:
> On Mon, Feb 04, 2008 at 04:00:30PM +0100, Marc Donner wrote:
> > i have here a few wimax 802.16e zyxel pcmcia cards, which only work on
> > windows. is anybody interrested in developing a driver for these wimax
> > cards?
>
> I might be interested.  Do you hvae programming documentation for
> these cards?
no, the cards have runcom chipsets, and i don't know if there are programming 
documentations availible.

> We currently don't have any wimax support in the kernel, but I know of
> a project working on it.  They are using Intel hardware -- it would
> be good to have other hardware to validate their work before merging
> it into the kernel.
i can do some testing if it is required, we have a trial network running. and 
a few alcatel basestations in the lab.

>
> John


