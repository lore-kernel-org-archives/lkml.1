Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYL2D4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYL2D4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 22:56:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751508AbYL2D4c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 22:56:32 -0500
Received: from vms173001pub.verizon.net ([206.46.173.1]:46727 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYL2D4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 22:56:32 -0500
Date: Sun, 28 Dec 2008 22:56:27 -0500 (EST)
From: Len Brown <lenb@kernel.org>
Subject: Re: Patch enabling Bluetooth for Asus EEE 901
In-reply-to: <20081228145835.GB12853@srcf.ucam.org>
X-X-Sender: lenb@localhost.localdomain
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Ondrej Zajicek <santiago@crfreenet.org>, corentincj@iksaif.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       acpi4asus-user@lists.sourceforge.net
Message-id: <alpine.LFD.2.00.0812282245450.4738@localhost.localdomain>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
References: <20081228102026.GA18096@localhost>
 <20081228145835.GB12853@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 28 Dec 2008, Matthew Garrett wrote:

> On Sun, Dec 28, 2008 at 11:20:27AM +0100, Ondrej Zajicek wrote:
> > eeepc-laptop driver has interface for enabling/disabling
> > Bluetooth, but it does not work. This patch fixes it.
> 
> An identical patch was posted at the start of the month in 
> <20081203203111.GA28234@earth.li> - Len, are you picking up patches from 
> -acpi at the moment, or do they need to be sent to you as well?

Re: list
The list for this driver is acpi4asus-user@lists.sourceforge.net

I'm not on that list, but presumably the maintainer,
Corentin Chary, is.

When I see patches for the platform specific drivers on
linux-acpi, I generally do try to pick them up, but I usually
request an ACK from the primary maintainer --
for often I have no means by inspection or testing
to verify the change, and that maintainer is the one
who gets the headache if the patch causes problems.

I'd pick them up if I see them on lkml as well - but I only
see lkml messages if they are addressed to me or if they
have the word "ACPI" in them.

Finally, I'd definitely pick them up if the primary
maintainer forwards them to me.

I've been offline since before the holidays,
just getting back online now.  Apparently I didn't find the
holidays as boring as Linus did.

cheers,
Len Brown, Intel Open Source Technology Center
