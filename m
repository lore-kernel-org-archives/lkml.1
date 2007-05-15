Return-Path: <linux-kernel-owner+w=401wt.eu-S1759381AbXEOSJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381AbXEOSJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 14:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbXEOSJh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 14:09:37 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28228 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754948AbXEOSJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 14:09:37 -0400
Date: Tue, 15 May 2007 11:12:50 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: jroberson@gtcocalcomp.com
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: Cannot find our GTCO USB Driver in the 2.6.22-rc1 kernel
Message-Id: <20070515111250.e869634b.randy.dunlap@oracle.com>
In-Reply-To: <1179251243.3101.57.camel@EdgyEft.Home>
References: <1176912010.6215.17.camel@EdgyEft.Home>
	<20070418181859.GA8658@suse.de>
	<1178046346.14152.43.camel@EdgyEft.Home>
	<20070502005252.GA23349@suse.de>
	<1178693022.4044.62.camel@EdgyEft.Home>
	<20070509072130.GA24274@suse.de>
	<1178768377.11163.3.camel@EdgyEft.Home>
	<20070511091845.GA3652@suse.de>
	<1179193541.3101.25.camel@EdgyEft.Home>
	<20070515030038.GA8159@suse.de>
	<1179251243.3101.57.camel@EdgyEft.Home>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 10:47:23 -0700 Jeremy Roberson wrote:

> I just got finished configuring the 2.6.22-rc1 kernel and noticed that
> the driver for my GTCO USB Digitizer isn't listed anymore.  For that
> matter, non of the tablet drivers appear to be there.  I did notice that
> there is a new Tablet section but, it's empty.  Will the Tablet drivers
> be put back in for the 2.6.22 release?

I see the driver listed in the Tablets section, but first
you must enable/check the Tablets entry...
Does that work/help you?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
