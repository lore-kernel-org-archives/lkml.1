Return-Path: <linux-kernel-owner+w=401wt.eu-S1762236AbYG3OR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762236AbYG3OR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 10:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756055AbYG3ORR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 10:17:17 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54824 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754277AbYG3ORQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 10:17:16 -0400
Date: Wed, 30 Jul 2008 10:17:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Frost <artusemrys@yahoo.com>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>,
       Matt Frost <artusemrys@sbcglobal.net>
Subject: Re: [usb-storage] BUG: SCSI: usb storage SDHC card doesn't work in
 2.6.27-rc1
In-Reply-To: <20080730052139.GG6091@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.44L0.0807301016010.2584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jul 2008, Matthew Dharm wrote:

> Actually, I'm seriously starting to think that US_FL_IGNORE_RESIDUE should
> just become a sysfs parameter which defaults to the 'ignore' state...

We have to be careful; there definitely are devices out there which 
need to use the Residue.

Alan Stern

