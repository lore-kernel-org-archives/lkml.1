Return-Path: <linux-kernel-owner+w=401wt.eu-S2993077AbXBRCL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993077AbXBRCL5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 21:11:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993079AbXBRCL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 21:11:57 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:52483 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993077AbXBRCL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 21:11:56 -0500
Date: Sat, 17 Feb 2007 20:17:09 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Theodore Tso <tytso@mit.edu>, Artem Bityutskiy <dedekind@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>,
       Frank Haverkamp <haver@vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 15/44 take 2] [UBI] scanning unit header
Message-ID: <20070218021708.GG1038@crusty.rchland.ibm.com>
References: <20070217165424.5845.4390.sendpatchset@localhost.localdomain> <20070217165540.5845.31238.sendpatchset@localhost.localdomain> <20070217230746.GD16522@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070217230746.GD16522@thunk.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 17, 2007 at 06:07:46PM -0500, Theodore Tso wrote:
> 
> This is a general comment that applies across your entire patchset.
> It would be a lot easier to review the patchset if you put the Docbook
> description of the function with the .c file instead of the .h file.
> This will also make it much more likely that when you or other people
> update the code function, that the documentation will get updated as
> well.
> 
> I'd recommend doing this along with combining all of your *.h files
> into a ubi_private.h and ubi.h file.

I agree.  Thanks for the suggestions Ted.

josh
