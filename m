Return-Path: <linux-kernel-owner+w=401wt.eu-S1758942AbZANE3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758942AbZANE3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 23:29:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZANE3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 23:29:44 -0500
Received: from SouthBend-74.pgzn.com ([206.212.253.74]:25672 "EHLO
	southbend-74.pgzn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677AbZANE3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 23:29:43 -0500
Subject: Re: USB memory card reader and 64MB SD card - 2.6.28-git14
From: rhubbell <rhubbell@ihubbell.com>
Reply-To: RHubbell@ihubbell.com
To: Robert Hancock <hancockr@shaw.ca>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <496D5C7A.9040505@shaw.ca>
References: <1231621530.4495.36.camel@127> <49693575.2030007@shaw.ca>
	 <1231829328.19241.3.camel@127>  <496D5C7A.9040505@shaw.ca>
Content-Type: text/plain
Organization: iHubbell.com
Date: Tue, 13 Jan 2009 20:29:39 -0800
Message-Id: <1231907379.4299.35.camel@127>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - southbend-74.pgzn.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ihubbell.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-13 at 21:31 -0600, Robert Hancock wrote:
> rhubbell wrote:
> > Darn, I meant to respond to the list also.
> > Anyway there is no dmesg output for the card. 
> > The dmesg output looks correct with the 128MB card.
> > 
> > Here's for the 128:
> > scsi0 : SCSI emulation for USB Mass Storage devices
> > usb-storage: device found at 2
> > usb-storage: waiting for device to settle before scanning
> > scsi 0:0:0:0: Direct-Access              USB Card Reader  1.01 PQ: 0 ANSI: 0 CCS
> > sd 0:0:0:0: [sda] 251904 512-byte hardware sectors: (128 MB/123 MiB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
> > sd 0:0:0:0: [sda] Assuming drive cache: write through
> > sd 0:0:0:0: [sda] 251904 512-byte hardware sectors: (128 MB/123 MiB)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
> > sd 0:0:0:0: [sda] Assuming drive cache: write through
> >  sda: sda1
> > sd 0:0:0:0: [sda] Attached SCSI removable disk
> > sd 0:0:0:0: Attached scsi generic sg0 type 0
> > usb-storage: device scan complete
> 
> That output seems rather normal.. If you're not getting anything like 
> that with the other card though, I would tend to suspect some kind of 
> issue with the card, the reader or some kind of incompatibility between 
> them. Certainly all the USB resets from the other output would tend to 
> suggest the reader isn't responding properly with that card installed..

I found another SD card and I am unable to read that.
I suppose the reader could have a problem, although it's fairly
simple, the led indicator blinks on card insertion.

The card did read in a PS3. Will try another reader.


