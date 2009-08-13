Return-Path: <linux-kernel-owner+w=401wt.eu-S1753503AbZHMOZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbZHMOZu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 10:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753141AbZHMOZt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 10:25:49 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:53321 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbZHMOZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 10:25:48 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] [RFC] usb: Add support for runtime power management of the hcd
Date: Thu, 13 Aug 2009 16:26:33 +0200
User-Agent: KMail/1.10.3 (Linux/2.6.31-rc4-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
       Greg KH <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <200908081625.57333.rjw@sisk.pl> <200908131416.42189.oliver@neukum.org> <20090813123034.GA25770@srcf.ucam.org>
In-Reply-To: <20090813123034.GA25770@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908131626.33891.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 13. August 2009 14:30:34 schrieb Matthew Garrett:
> > Your earlier failures don't look promising regarding BIOSes.
> > What do you have in mind?
>
> They range from pragmatic to ugly. We could blacklist all Dells, though
> I'm trying to find out if there's a BIOS date that guarantees the system
> is fixed. Alternatively, it's a single-line bug in the DSDT - we could
> implement some kind of fixup in the ACPI parsing code. I find the latter
> interesting but possibly too hideous to live :)

Is there any indication only those BIOSes are affected?

	Regards
		Oliver

