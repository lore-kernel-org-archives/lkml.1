Return-Path: <linux-kernel-owner+w=401wt.eu-S1755248AbYBOPXi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbYBOPXi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 10:23:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752415AbYBOPX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 10:23:29 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:36603 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYBOPX2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 10:23:28 -0500
Date: Fri, 15 Feb 2008 07:20:08 -0800
From: Greg KH <greg@kroah.com>
To: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: jdmason@kudzu.us, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       discuss@x86-64.org
Subject: Re: pci_get_device_reverse(), why does Calgary need this?
Message-ID: <20080215152008.GA1975@kroah.com>
References: <20080213001506.GA13933@kroah.com> <20080213001638.GB13933@kroah.com> <20080213093225.GA16985@rhun.haifa.ibm.com> <20080213173203.GC10733@kroah.com> <20080213174711.GB22274@rhun.haifa.ibm.com> <20080213181459.GA8960@kroah.com> <20080215071703.GA9022@kroah.com> <20080215074827.GE4334@rhun.haifa.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080215074827.GE4334@rhun.haifa.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 15, 2008 at 09:48:27AM +0200, Muli Ben-Yehuda wrote:
> In conclusion, our usage doesn't seem lika a good fit for the probe
> approach, although it could probably converted provided we got the
> ordering right with regards to regular PCI device
> initialization. Doesn't seem to be worth the effort.

After reading this, and looking at the code again, I agree.  Thanks for
the great explaination, I'll leave the code alone now :)

thanks,

greg k-h
