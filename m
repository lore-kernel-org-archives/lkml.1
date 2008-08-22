Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbYHVUta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbYHVUta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 16:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755798AbYHVUtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 16:49:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:46439 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722AbYHVUtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 16:49:05 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@suse.cz>
Subject: Re: autosuspend for SCSI devices
Date: Fri, 22 Aug 2008 22:52:51 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: oneukum@suse.de, linux-pm@lists.linux-foundation.org,
       James.Bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org,
       teheo@novell.com, stefanr@s5r6.in-berlin.de, Martin.Leisner@xerox.com
References: <20080822105626.GA9475@elf.ucw.cz>
In-Reply-To: <20080822105626.GA9475@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808222252.52947.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 22 of August 2008, Pavel Machek wrote:
> From: Alan Stern <stern@rowland.harvard.edu>
> 
> Add support for autosuspend/autoresume of the SCSI devices. Lowlevel
> driver can use it to spin the disk down... and it is neccessary step
> for powering down the controllers.
> 
> Spinning down the disk is useful - saves ~0.5W here, and it is last
> major thing we can do to save power on some small machines like
> Kohjinsha subnotebooks.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

-ENOPATCH
