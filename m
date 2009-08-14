Return-Path: <linux-kernel-owner+w=401wt.eu-S1757036AbZHNVh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757036AbZHNVh6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 17:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756711AbZHNVh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 17:37:58 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49531 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756697AbZHNVh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 17:37:57 -0400
Date: Fri, 14 Aug 2009 17:37:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: linux-pm <linux-pm@lists.linux-foundation.org>,
       linux-acpi <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [RFC][PATCH 0/3] PM: Asynchronous suspend and resume
In-Reply-To: <200908142331.26855.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0908141735410.2922-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Aug 2009, Rafael J. Wysocki wrote:

> > I think it would be worthwhile to track down these unknown problems and 
> > dependencies.  It won't be easy, though...
> 
> Agreed.
> 
> Hm.  Perhaps it's a good idea to get this code in, so that people can play
> with it.  The more people will look into this, the greater the chance to
> identify problematic drivers.

We don't know if the final form will resemble this at all.  So yes, it 
should be made available for testing purposes (especially if there's 
some mechanism for listing dependencies), but it shouldn't go into 
linux-next or anything like that.

Alan Stern

