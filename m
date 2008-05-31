Return-Path: <linux-kernel-owner+w=401wt.eu-S1752887AbYEaHba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752887AbYEaHba (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2008 03:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751220AbYEaHbU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 May 2008 03:31:20 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47374 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYEaHbT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2008 03:31:19 -0400
Date: Sat, 31 May 2008 00:29:13 -0700
From: Greg KH <greg@kroah.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oliver Neukum <oliver@neukum.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: [Bug #10630] USB devices plugged into dock are not discoverred
	until reload of ehci-hcd
Message-ID: <20080531072913.GA15803@kroah.com>
References: <1NnHL0AVfcI.A.hJC.ZdIOIB@albercik> <TW_YzGo9TFP.A.LYF.TgIOIB@albercik> <200805251153.26882.oliver@neukum.org> <200805292317.15117.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805292317.15117.rjw@sisk.pl>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2008 at 11:17:14PM +0200, Rafael J. Wysocki wrote:
> On Sunday, 25 of May 2008, Oliver Neukum wrote:
> > Am Samstag 24 Mai 2008 22:31:39 schrieb Rafael J. Wysocki:
> > > This message has been generated automatically as a part of a report
> > > of recent regressions.
> > > 
> > > The following bug entry is on the current list of known regressions
> > > from 2.6.25.  Please verify if it still should be listed.
> > 
> > Alan's patch fixes the issue. It has been tested and submitted.
> 
> Has it reached the Linus' tree already?

Yes, it should now be in there, as of last night.

Alan, is this correct?

thanks,

greg k-h
