Return-Path: <linux-kernel-owner+w=401wt.eu-S934209AbXCVTyv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209AbXCVTyv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 15:54:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934207AbXCVTyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 15:54:51 -0400
Received: from eazy.amigager.de ([213.239.192.238]:57211 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934209AbXCVTyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 15:54:49 -0400
Date: Thu, 22 Mar 2007 20:54:48 +0100
From: Tino Keitel <tino.keitel@gmx.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [linux-usb-devel] possible USB regression with 2.6.21-rc4: iPod doesn't work
Message-ID: <20070322195448.GA17521@dose.home.local>
Mail-Followup-To: Alan Stern <stern@rowland.harvard.edu>,
	linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <20070322085451.GB10598@dose.home.local> <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.44L0.0703221539440.4669-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 15:40:40 -0400, Alan Stern wrote:
> On Thu, 22 Mar 2007, Tino Keitel wrote:
> 
> > On Thu, Mar 22, 2007 at 09:50:29 +0100, Oliver Neukum wrote:
> > > Am Mittwoch, 21. März 2007 21:47 schrieb Tino Keitel:
> > > 
> > > > along with other USB error messages. I tried a hub with own power
> > > > supply and a USB port on the computer. A full log is attached.
> > > 
> > > Your log basically shows a hub going berserk.
> 
> Or a bad USB transceiver.  _Something_ is generating those overcurrent 
> warnings, and it sure looks like a hardware malfunction.

But it works with 2.6.20.

Regards,
Tino
