Return-Path: <linux-kernel-owner+w=401wt.eu-S1763616AbXKOAk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763616AbXKOAk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 19:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755513AbXKOAkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 19:40:16 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54496 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755462AbXKOAkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 19:40:14 -0500
Date: Wed, 14 Nov 2007 16:39:54 -0800
From: Gary Hade <garyhade@us.ibm.com>
To: Alex Chiang <achiang@hp.com>
Cc: Gary Hade <garyhade@us.ibm.com>, Matthew Wilcox <matthew@wil.cx>,
       Greg KH <greg@kroah.com>, gregkh@suse.de, kristen.c.accardi@intel.com,
       lenb@kernel.org, rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, kaneshige.kenji@jp.fujitsu.com,
       pcihpd-discuss@lists.sourceforge.net, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/5, v2] Physical PCI slot objects
Message-ID: <20071115003954.GB6269@us.ibm.com>
References: <20071114193605.GA25002@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071114193605.GA25002@ldl.fc.hp.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2007 at 12:36:05PM -0700, Alex Chiang wrote:
> * Alex Chiang <achiang@hp.com>:
> > 
> > Actually, I just reworked my patch this morning, and believe that
> > I have a much cleaner implementation now that should fix a lot of
> > the errors you saw.

Sorry, I lost access to the x3850 that I was using and 
may not be able to get back on it until early next week.

I think I will go ahead and send you the comments
in response to your earlier message that I was going
to hold off on until I tried your revised patches.
It may contain something you haven't considered.

Gary

-- 
Gary Hade
System x Enablement
IBM Linux Technology Center
503-578-4503  IBM T/L: 775-4503
garyhade@us.ibm.com
http://www.ibm.com/linux/ltc
