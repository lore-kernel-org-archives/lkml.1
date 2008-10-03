Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYJCT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYJCT4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbYJCT4m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:56:42 -0400
Received: from www.sr71.net ([198.145.64.142]:53938 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYJCT4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:56:42 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0810031522280.6462-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0810031522280.6462-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 12:56:40 -0700
Message-Id: <1223063800.7944.62.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 15:23 -0400, Alan Stern wrote:
> On Fri, 3 Oct 2008, Alan Stern wrote:
> > You should use usbmon (see Documentation/usb/usbmon.txt) to record a 
> > trace of everything happening on bus 3.  And to keep things simple, you 
> > should unplug all the USB devices except for one of the magical 
> > disappearing hubs.
> 
> Better still, get two traces: one from each kernel.  Then they can be 
> compared.

What should I record on the good kernel?  Just the devices being
connected?

-- Dave

