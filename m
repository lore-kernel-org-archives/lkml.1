Return-Path: <linux-kernel-owner+w=401wt.eu-S1759447AbYH2VXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759447AbYH2VXG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 17:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757404AbYH2VWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 17:22:52 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2554 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757279AbYH2VWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 17:22:50 -0400
Date: Fri, 29 Aug 2008 17:22:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Arnd Bergmann <arnd@arndb.de>
cc: linuxppc-dev@ozlabs.org, <dbrownell@users.sourceforge.net>,
       <greg@kroah.com>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>, Scott Wood <scottwood@freescale.com>,
       Li Yang <leoli@freescale.com>
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
 driver
In-Reply-To: <200808291938.26651.arnd@arndb.de>
Message-ID: <Pine.LNX.4.44L0.0808291722160.13185-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Aug 2008, Arnd Bergmann wrote:

> On Friday 29 August 2008, Alan Stern wrote:
> > I thought you _were_ arguing against that.  Unless I misunderstood,
> > your original complaint was that since each peripheral controller
> > driver defines usb_gadget_{un}register_driver, there can be only one
> > controller driver loaded at a time.
> 
> That's probably where the misunderstanding came from: I did not expect
> more than one driver to actually be useful on a given system, but that
> should IMHO not prevent you from loading the drivers using modprobe, or
> building them all into the kernel.

All right, then we're in agreement.  :-)

Alan Stern

