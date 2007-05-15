Return-Path: <linux-kernel-owner+w=401wt.eu-S1760869AbXEOSMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760869AbXEOSMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:12:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754779AbXEOSMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:12:10 -0400
Received: from webmail.gtco.com ([209.36.34.20]:62415 "EHLO
	mdmailserv.gtcocalcomp.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754328AbXEOSMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:12:09 -0400
Subject: Re: Cannot find our GTCO USB Driver in the 2.6.22-rc1 kernel
From: Jeremy Roberson <jroberson@gtcocalcomp.com>
Reply-To: jroberson@gtcocalcomp.com
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
In-Reply-To: <20070515111250.e869634b.randy.dunlap@oracle.com>
References: <1176912010.6215.17.camel@EdgyEft.Home>
	 <20070418181859.GA8658@suse.de> <1178046346.14152.43.camel@EdgyEft.Home>
	 <20070502005252.GA23349@suse.de> <1178693022.4044.62.camel@EdgyEft.Home>
	 <20070509072130.GA24274@suse.de> <1178768377.11163.3.camel@EdgyEft.Home>
	 <20070511091845.GA3652@suse.de> <1179193541.3101.25.camel@EdgyEft.Home>
	 <20070515030038.GA8159@suse.de> <1179251243.3101.57.camel@EdgyEft.Home>
	 <20070515111250.e869634b.randy.dunlap@oracle.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GTCO CalComp
Date: Tue, 15 May 2007 11:12:07 -0700
Message-Id: <1179252727.3101.68.camel@EdgyEft.Home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 15 May 2007 18:12:22.0291 (UTC) FILETIME=[954A6E30:01C7971C]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

LOL.  Thanks, I forgot to enable Tablets before entering the Tablets
tree.

On Tue, 2007-05-15 at 11:12 -0700, Randy Dunlap wrote:
> On Tue, 15 May 2007 10:47:23 -0700 Jeremy Roberson wrote:
> 
> > I just got finished configuring the 2.6.22-rc1 kernel and noticed that
> > the driver for my GTCO USB Digitizer isn't listed anymore.  For that
> > matter, non of the tablet drivers appear to be there.  I did notice that
> > there is a new Tablet section but, it's empty.  Will the Tablet drivers
> > be put back in for the 2.6.22 release?
> 
> I see the driver listed in the Tablets section, but first
> you must enable/check the Tablets entry...
> Does that work/help you?
> 
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
-- 
Jeremy Roberson
Software Engineer
Interwrite Learning

"Do not go gentle into that good night,
Old age should burn and rave at the 
close of the day; Rage, rage against the
dying of the light."
- Dylan Thomas



Note: The information contained within this electronic transmission is
intended by Interwrite Learning for the use of the named individual or
entity to which it is directed and contains confidential and/or
privileged information.  It is not intended for transmission or receipt
by anyone other than the named addressee or entity.  It should not be
forwarded or copied to any unauthorized persons.  If you have received
this is error, please remove it from your system, without copying or
forwarding it and notify the sender by return email. Thank you.
