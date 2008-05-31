Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbYEaQ3D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbYEaQ3D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 12:29:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbYEaQ2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 12:28:51 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2807 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752940AbYEaQ2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 12:28:51 -0400
Date: Sat, 31 May 2008 12:28:49 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Greg KH <greg@kroah.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
 until reload of ehci-hcd
In-Reply-To: <20080531072913.GA15803@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0805311227090.6625-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 May 2008, Greg KH wrote:

> On Thu, May 29, 2008 at 11:17:14PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 25 of May 2008, Oliver Neukum wrote:
> > > Am Samstag 24 Mai 2008 22:31:39 schrieb Rafael J. Wysocki:
> > > > This message has been generated automatically as a part of a report
> > > > of recent regressions.
> > > > 
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.25.  Please verify if it still should be listed.
> > > 
> > > Alan's patch fixes the issue. It has been tested and submitted.
> > 
> > Has it reached the Linus' tree already?
> 
> Yes, it should now be in there, as of last night.
> 
> Alan, is this correct?

Confirmed; the patch is now in Linus's tree:

	Commit d1f114d12bb4db3147e1b1342ae31083c5a79c84

Alan Stern

