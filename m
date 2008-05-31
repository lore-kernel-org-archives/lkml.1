Return-Path: <linux-kernel-owner+w=401wt.eu-S1755036AbYEaSbV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbYEaSbV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 14:31:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753458AbYEaSbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 14:31:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51235 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753434AbYEaSbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 14:31:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred until reload of ehci-hcd
Date: Sat, 31 May 2008 20:31:44 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
References: <Pine.LNX.4.44L0.0805311227090.6625-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0805311227090.6625-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805312031.45521.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 31 of May 2008, Alan Stern wrote:
> On Sat, 31 May 2008, Greg KH wrote:
> 
> > On Thu, May 29, 2008 at 11:17:14PM +0200, Rafael J. Wysocki wrote:
> > > On Sunday, 25 of May 2008, Oliver Neukum wrote:
> > > > Am Samstag 24 Mai 2008 22:31:39 schrieb Rafael J. Wysocki:
> > > > > This message has been generated automatically as a part of a report
> > > > > of recent regressions.
> > > > > 
> > > > > The following bug entry is on the current list of known regressions
> > > > > from 2.6.25.  Please verify if it still should be listed.
> > > > 
> > > > Alan's patch fixes the issue. It has been tested and submitted.
> > > 
> > > Has it reached the Linus' tree already?
> > 
> > Yes, it should now be in there, as of last night.
> > 
> > Alan, is this correct?
> 
> Confirmed; the patch is now in Linus's tree:
> 
> 	Commit d1f114d12bb4db3147e1b1342ae31083c5a79c84

Thanks, closed.

Rafael
