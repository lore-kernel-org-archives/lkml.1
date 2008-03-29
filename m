Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYC2O4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYC2O4o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2008 10:56:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751964AbYC2O4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Mar 2008 10:56:34 -0400
Received: from netrider.rowland.org ([192.131.102.5]:1980 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751950AbYC2O4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2008 10:56:33 -0400
Date: Sat, 29 Mar 2008 10:56:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Marco Mangiante <marco.mangiante@gmail.com>
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>,
       <akpm@linux-foundation.org>
Subject: Re: [PROBLEM]: onda h600 express card don't work inside the elan
 u132 usb adapter
In-Reply-To: <42212ce70803290039p5d4a0ac5hc89ec572c2b222d@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0803291054220.16681-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Mar 2008, Marco Mangiante wrote:

> Hello,
> 
> > > Ah, I see with google that some people touched the u132-hcd driver, so
> > > maybe it is supported.
> >
> > It is not supported.  The people who touched it were making minor or
> > cosmetic changes.
> 
> so I have no hope to see my onda h600 card to work on linux inside the
> elan u132? :-(

You shouldn't think there's no hope at all.  Maybe you can find 
somebody who will fix u132-hcd or will rewrite it entirely.  Or if you 
want it badly enough, you could fix the driver yourself.

Alan Stern

