Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548Ab0CBXsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:48:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57726 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758041Ab0CBXru (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:47:50 -0500
Date: Tue, 2 Mar 2010 15:47:00 -0800
From: Greg KH <gregkh@suse.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org, "Lee, Chun-Yi" <jlee@novell.com>,
       Lennart Poettering <mzxreary@0pointer.de>
Subject: Re: [PATCH 57/62] msi-laptop: Add threeg sysfs file for support
 query 3G state by standard 66/62 ec command
Message-ID: <20100302234700.GB1680@suse.de>
References: <20100302230933.GA32287@kroah.com>
 <1267572541-410-57-git-send-email-gregkh@suse.de>
 <20100302233616.GA13739@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100302233616.GA13739@srcf.ucam.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 02, 2010 at 11:36:16PM +0000, Matthew Garrett wrote:
> On Tue, Mar 02, 2010 at 03:28:56PM -0800, Greg Kroah-Hartman wrote:
> 
> > Add threeg sysfs file for support query 3G state by standard 66/62 ec
> > command, the MSI standard ec interface supported this feature.
> 
> No. Just use the rfkill interface.

Does rfkill support 3G?  I thought it was only for wireless (80211)
stuff.

thanks,

greg k-h
