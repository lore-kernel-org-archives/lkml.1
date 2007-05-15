Return-Path: <linux-kernel-owner+w=401wt.eu-S1760380AbXEOS5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760380AbXEOS5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755873AbXEOS4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:56:54 -0400
Received: from webmail.gtcocalcomp.com ([209.36.34.20]:6998 "EHLO
	mdmailserv.gtcocalcomp.local" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754940AbXEOS4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:56:53 -0400
Subject: Re: [linux-usb-devel] Cannot find our GTCO USB Driver in the
	2.6.22-rc1 kernel
From: Jeremy Roberson <jroberson@gtcocalcomp.com>
Reply-To: jroberson@gtcocalcomp.com
To: Till Harbaum / Lists <lists@harbaum.org>
Cc: linux-usb-devel@lists.sourceforge.net,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200705152038.53676.lists@harbaum.org>
References: <1176912010.6215.17.camel@EdgyEft.Home>
	 <20070515111250.e869634b.randy.dunlap@oracle.com>
	 <1179252727.3101.68.camel@EdgyEft.Home>
	 <200705152038.53676.lists@harbaum.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: GTCO CalComp
Date: Tue, 15 May 2007 11:56:51 -0700
Message-Id: <1179255411.3101.79.camel@EdgyEft.Home>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 15 May 2007 18:57:07.0239 (UTC) FILETIME=[D5A4FB70:01C79722]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A very good question.  Had it been, I probably would not have missed it.

On Tue, 2007-05-15 at 20:38 +0200, Till Harbaum / Lists wrote:
> Hi,
> 
> which leads to the question: Why is the "Enable Tablets" entry not
> inside the tablets menu. This way it's more obvious that it's disabled
> if it's the only entry in the menu. Plus the parent menu gets
> cleaned up as well.
> 
> Till
> 
> Am Dienstag 15 Mai 2007 schrieb Jeremy Roberson:
> > LOL.  Thanks, I forgot to enable Tablets before entering the Tablets
> > tree.
> >
> > On Tue, 2007-05-15 at 11:12 -0700, Randy Dunlap wrote:
> > > On Tue, 15 May 2007 10:47:23 -0700 Jeremy Roberson wrote:
> > > > I just got finished configuring the 2.6.22-rc1 kernel and noticed that
> > > > the driver for my GTCO USB Digitizer isn't listed anymore.  For that
> > > > matter, non of the tablet drivers appear to be there.  I did notice
> > > > that there is a new Tablet section but, it's empty.  Will the Tablet
> > > > drivers be put back in for the 2.6.22 release?
> > >
> > > I see the driver listed in the Tablets section, but first
> > > you must enable/check the Tablets entry...
> > > Does that work/help you?
> > >
> > > ---
> > > ~Randy
> > > *** Remember to use Documentation/SubmitChecklist when testing your code
> > > ***
> 
> 
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
