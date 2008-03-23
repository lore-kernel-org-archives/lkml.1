Return-Path: <linux-kernel-owner+w=401wt.eu-S1757232AbYCWCKg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232AbYCWCKg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 22:10:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753599AbYCWCK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 22:10:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4483 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752603AbYCWCK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 22:10:27 -0400
Date: Sat, 22 Mar 2008 22:10:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Andrew Morton <akpm@linux-foundation.org>
cc: Marco Mangiante <marco.mangiante@gmail.com>,
       <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [PROBLEM]: onda h600 express card don't work inside the elan
 u132 usb adapter
In-Reply-To: <20080322173147.d94740b7.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.44L0.0803222208050.13906-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Mar 2008, Andrew Morton wrote:

> On Sat, 22 Mar 2008 11:51:28 +0100 "Marco Mangiante" <marco.mangiante@gmail.com> wrote:
> 
> > I'm trying to use the onda h600 (a pcmcia express card for UMTS-HSDPA)
> > on an assembled desktop under kubuntu 7.04 (kernel 2.6.22-14-generic),
> > but the problem is present even in 7.10 and 8.04 alpha 6 (this has a
> > 2.6.24-8-generic kernel). The card apparentely have a ZTE MF330
> > chipset, and is OHCI compliant.
> > 
> > I want to use it with elan u132, an usb external adapter for
> > UMTS-HSDPA express cards. In a document found on the net and written
> > by Tony Olech (the author and maintainer of the elan u132 linux driver
> > in Elan Digital Systems), I read that the device (u132) must load 2
> > modules: the ftdi-u132 when it is plugged in the usb port, and the
> > u132-hcd, when it recognize an express card inside it.

As far as I know, the u132-hcd driver isn't being maintained by anybody 
except the author Tony Olech -- and maybe not even by him.

Alan Stern

