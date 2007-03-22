Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbXCVTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbXCVTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:40:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934200AbXCVTks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:40:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:47757 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934199AbXCVTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:40:47 -0400
Date: Thu, 22 Mar 2007 15:40:40 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tino Keitel <tino.keitel@gmx.de>
cc: linux-usb-devel@lists.sourceforge.net, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod
 doesn't work
In-Reply-To: <20070322085451.GB10598@dose.home.local>
Message-ID: <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2007, Tino Keitel wrote:

> On Thu, Mar 22, 2007 at 09:50:29 +0100, Oliver Neukum wrote:
> > Am Mittwoch, 21. März 2007 21:47 schrieb Tino Keitel:
> > 
> > > along with other USB error messages. I tried a hub with own power
> > > supply and a USB port on the computer. A full log is attached.
> > 
> > Your log basically shows a hub going berserk.

Or a bad USB transceiver.  _Something_ is generating those overcurrent 
warnings, and it sure looks like a hardware malfunction.

Alan Stern

