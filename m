Return-Path: <linux-kernel-owner+w=401wt.eu-S934196AbYBUVDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934196AbYBUVDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 16:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765698AbYBUVCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 16:02:47 -0500
Received: from mga02.intel.com ([134.134.136.20]:20176 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934739AbYBUVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 16:02:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,388,1199692800"; 
   d="scan'208";a="258964582"
From: Jesse Barnes <jesse.barnes@intel.com>
To: Romano Giannetti <romano@dea.icai.upcomillas.es>
Subject: Re: [Suspend-devel] 2.6.25-rc2 System no longer powers off  aftersuspend-to-disk. Screen becomes green.
Date: Thu, 21 Feb 2008 13:02:26 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Chua <jeff.chua.linux@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       suspend-devel List <suspend-devel@lists.sourceforge.net>,
       Dave Airlie <airlied@linux.ie>, Greg KH <gregkh@suse.de>,
       lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-acpi@vger.kernel.org
References: <Pine.LNX.4.64.0802210101050.3576@boston.corp.fedex.com> <b6a2187b0802201002t315548b5uac623759723842d0@mail.gmail.com> <1203623002.3420.6.camel@localhost>
In-Reply-To: <1203623002.3420.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802211302.27002.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 21, 2008 11:43 am Romano Giannetti wrote:
> > > Let's try to narrow it down to what the interaction is. Are you using
> > > something like acpi_sleep=s3_bios or similar?
> >
> > No. Not additional command line option except for resume=/dev/sda3
> > reboot=bios
>
> My laptop (a Toshiba satellite U305, intel 945GM chipset, used to need
> s2ram -f -p -m to STR correctly. In 2.6.25-rc2 I can simply STR with
> echo mem > /sys/power/state.

Cool, glad to hear at least one success report. :)

> This communication contains confidential information. It is for the
> exclusive use of the intended addressee. If you are not the intended
> addressee, please note that any form of distribution, copying or use of
> this communication or the information in it is strictly prohibited by law.
> If you have received this communication in error, please immediately notify
> the sender by reply e-mail and destroy this message. Thank you for your
> cooperation.

Really?  This contains confidential information?  I'd better notify you and 
destroy this message now... :)

Jesse
