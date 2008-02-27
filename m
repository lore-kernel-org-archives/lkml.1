Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYB0OcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYB0OcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 09:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753412AbYB0OcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 09:32:13 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:46229 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753341AbYB0OcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:32:13 -0500
Date: Wed, 27 Feb 2008 09:32:12 -0500
To: Nuno Tavares <nuno.tavares@dri.pt>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dell OptiPlex 320 - Core 2 Duo
Message-ID: <20080227143212.GB1289@csclub.uwaterloo.ca>
References: <20080225093914.GB4375@ics.muni.cz> <20080225220720.GA4523@ics.muni.cz> <20080225230035.GA14503@khazad-dum.debian.net> <200802260005.02613.rjw@sisk.pl> <1204113265.6167.13.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1204113265.6167.13.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2008 at 11:54:25AM +0000, Nuno Tavares wrote:
> Kernel command line:
> root=/dev/disk/by-id/scsi-SATA_WDC_WD800JD-75M_WD-WMAM9TA95509-part2
> apm=off acpi=off mce=off barrier=off ide=nodma idewait=50 i8042.nomux

Multi processor requires acpi, so your acpi=off will disable all but the
first CPU.

Is the system really so broken that you have to tell the kernel to
disable everything?

--
Len Sorensen
