Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbZBCORJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbZBCORJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 09:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752358AbZBCOQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 09:16:56 -0500
Received: from cluster-d.mailcontrol.com ([85.115.60.190]:53772 "EHLO
	cluster-d.mailcontrol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbZBCOQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 09:16:55 -0500
Message-ID: <49885139.3070106@csr.com>
Date: Tue, 03 Feb 2009 14:14:17 +0000
From: David Vrabel <david.vrabel@csr.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] UWB and WUSB fixes
References: <49873632.6040108@csr.com> <20090203051244.GA1826@kroah.com>
In-Reply-To: <20090203051244.GA1826@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Feb 2009 14:14:16.0991 (UTC) FILETIME=[B2D522F0:01C98609]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Mon, Feb 02, 2009 at 06:06:42PM +0000, David Vrabel wrote:
>>  drivers/usb/host/whci/asl.c       |    9 +++++++--
>>  drivers/usb/host/whci/hw.c        |   15 +++++++++++++++
>>  drivers/usb/host/whci/pzl.c       |    9 +++++++--
>>  drivers/usb/host/whci/whcd.h      |    1 +
>>  drivers/usb/wusbcore/devconnect.c |    1 +
>>  drivers/usb/wusbcore/rh.c         |    3 +++
> 
> For patches under drivers/usb/ could you please route them through me?
> It makes things a bit easier to coordinate at times.  Not that there is
> a problem at all with these patches, but in the future it would be
> nicer.

This is more work for me (and you) and I don't see the benefit.  Could
you expand on what situations you see this as helping?

David
-- 
David Vrabel, Senior Software Engineer, Drivers
CSR, Churchill House, Cambridge Business Park,  Tel: +44 (0)1223 692562
Cowley Road, Cambridge, CB4 0WZ                 http://www.csr.com/
