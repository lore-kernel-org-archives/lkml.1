Return-Path: <linux-kernel-owner+w=401wt.eu-S1759237AbYCWWvL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759237AbYCWWvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 18:51:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756115AbYCWWu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 18:50:57 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1779 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756048AbYCWWu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 18:50:56 -0400
Date: Sun, 23 Mar 2008 18:50:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Marco Mangiante <marco.mangiante@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <akpm@linux-foundation.org>
Subject: Re: [PROBLEM]: onda h600 express card don't work inside the elan
 u132 usb adapter
In-Reply-To: <42212ce70803230310l446bff1cs33740a43d81eeb96@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0803231849550.6631-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 Mar 2008, Marco Mangiante wrote:

> Hello Alan,
> 
> > > > I want to use it with elan u132, an usb external adapter for
> > > > UMTS-HSDPA express cards. In a document found on the net and written
> > > > by Tony Olech (the author and maintainer of the elan u132 linux driver
> > > > in Elan Digital Systems), I read that the device (u132) must load 2
> > > > modules: the ftdi-u132 when it is plugged in the usb port, and the
> > > > u132-hcd, when it recognize an express card inside it.
> >
> > As far as I know, the u132-hcd driver isn't being maintained by anybody
> > except the author Tony Olech -- and maybe not even by him.
> 
> thanks for your response. This means that the elan u132 device is no
> more supported because the u132-hcd is not supported? If not, what is
> the substitute for it, if any exists?

I have no idea, sorry.  Maybe someone at Elan Digital Systems can help 
you.

Alan Stern

