Return-Path: <linux-kernel-owner+w=401wt.eu-S1754294AbYJCUzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbYJCUzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753013AbYJCUzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:55:39 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59603 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752966AbYJCUzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:55:38 -0400
Date: Fri, 3 Oct 2008 16:55:37 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Hansen <dave@sr71.net>
cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <1223063800.7944.62.camel@nimitz>
Message-ID: <Pine.LNX.4.44L0.0810031655130.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Dave Hansen wrote:

> On Fri, 2008-10-03 at 15:23 -0400, Alan Stern wrote:
> > On Fri, 3 Oct 2008, Alan Stern wrote:
> > > You should use usbmon (see Documentation/usb/usbmon.txt) to record a 
> > > trace of everything happening on bus 3.  And to keep things simple, you 
> > > should unplug all the USB devices except for one of the magical 
> > > disappearing hubs.
> > 
> > Better still, get two traces: one from each kernel.  Then they can be 
> > compared.
> 
> What should I record on the good kernel?  Just the devices being
> connected?

Never mind; the first trace was good enough.

Alan Stern

