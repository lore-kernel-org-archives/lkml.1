Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXEOSkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXEOSkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbXEOSkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:40:13 -0400
Received: from mo-p00-fb.rzone.de ([81.169.146.163]:55967 "EHLO
	mo-p00-fb.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763AbXEOSkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:40:12 -0400
From: Till Harbaum / Lists <lists@harbaum.org>
To: linux-usb-devel@lists.sourceforge.net, jroberson@gtcocalcomp.com
Subject: Re: [linux-usb-devel] Cannot find our GTCO USB Driver in the 2.6.22-rc1 kernel
Date: Tue, 15 May 2007 20:38:53 +0200
User-Agent: KMail/1.9.6
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
References: <1176912010.6215.17.camel@EdgyEft.Home> <20070515111250.e869634b.randy.dunlap@oracle.com> <1179252727.3101.68.camel@EdgyEft.Home>
In-Reply-To: <1179252727.3101.68.camel@EdgyEft.Home>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705152038.53676.lists@harbaum.org>
X-RZG-AUTH: lrVwt3eQkFsB0N4NN6ByxoEgzafUGJAl9sa8ZuPyEW4S2CcRRqQ/xUw=
X-RZG-CLASS-ID: mo00
X-RZG-CLASS-ID: mo00
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

which leads to the question: Why is the "Enable Tablets" entry not
inside the tablets menu. This way it's more obvious that it's disabled
if it's the only entry in the menu. Plus the parent menu gets
cleaned up as well.

Till

Am Dienstag 15 Mai 2007 schrieb Jeremy Roberson:
> LOL.  Thanks, I forgot to enable Tablets before entering the Tablets
> tree.
>
> On Tue, 2007-05-15 at 11:12 -0700, Randy Dunlap wrote:
> > On Tue, 15 May 2007 10:47:23 -0700 Jeremy Roberson wrote:
> > > I just got finished configuring the 2.6.22-rc1 kernel and noticed that
> > > the driver for my GTCO USB Digitizer isn't listed anymore.  For that
> > > matter, non of the tablet drivers appear to be there.  I did notice
> > > that there is a new Tablet section but, it's empty.  Will the Tablet
> > > drivers be put back in for the 2.6.22 release?
> >
> > I see the driver listed in the Tablets section, but first
> > you must enable/check the Tablets entry...
> > Does that work/help you?
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code
> > ***


