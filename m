Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbYBAQg0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbYBAQg0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 11:36:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754717AbYBAQgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 11:36:19 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:56086 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986AbYBAQgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:36:19 -0500
Message-ID: <47A34A7D.6030408@garzik.org>
Date: Fri, 01 Feb 2008 11:36:13 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       isdn4linux@listserv.isdn4linux.de, kkeil@suse.de
Subject: Re: [PATCH 0/5] isdn: fix section mismatch warnings in isdn
References: <20080201133838.GA13349@uranus.ravnborg.org>
In-Reply-To: <20080201133838.GA13349@uranus.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.3 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> I know Jeff Garzik has some ISDN clean-up patches pending
> but rather than waiting forever to have them acked I deciced
> to fix the warnings in the current kernel.


Please do...

Those patches are not going to be submitted for the current merge 
window, as I had higher priorities.  The PCI hotplug conversion is 
complete, but a few "rough edges" remain to be cleaned up -- then we 
must test, since none of this work is tested at all yet.

For anyone else curious about the ISDN PCI hotplug API conversion, it is 
available on the 'isdn-pci' branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/misc-2.6.git


	Jeff


