Return-Path: <linux-kernel-owner+w=401wt.eu-S934068AbZJJQV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934068AbZJJQV2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 12:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761966AbZJJQV1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 12:21:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:41756 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761952AbZJJQV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 12:21:26 -0400
Date: Sat, 10 Oct 2009 12:20:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 (and 2.6.32-rc3)
In-Reply-To: <1255144315.3387.0.camel@pasglop>
Message-ID: <Pine.LNX.4.44L0.0910101217190.3859-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Oct 2009, Benjamin Herrenschmidt wrote:

> On Fri, 2009-10-09 at 22:03 -0400, Alan Stern wrote:
> 
> > If it's not a hardware issue and the modem really does work okay in 
> > 2.6.31.1, you should also collect a usbmon trace under that kernel for 
> > comparison.
> 
> I put some logs at:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=14355
> 
> BTW. Do we have a nice GUI to browse these or it's time for me to work
> on my pygtk skills ? :-)

I don't know of any GUI for browsing these trace files.  On the other
hand I believe Wireshark is aware of usbmon's binary interface, so you
can use it to capture and browse packets.  For email purposes, I find
the simple text interface easier to use.

Alan Stern

