Return-Path: <linux-kernel-owner+w=401wt.eu-S1760863AbXGEOBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760863AbXGEOBz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 10:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757476AbXGEOBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 10:01:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53720 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674AbXGEOBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 10:01:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Thu, 5 Jul 2007 16:09:24 +0200
User-Agent: KMail/1.9.5
Cc: Oliver Neukum <oliver@neukum.org>, Miklos Szeredi <miklos@szeredi.hu>,
       paulus@samba.org, stern@rowland.harvard.edu, johannes@sipsolutions.net,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       pavel@ucw.cz, benh@kernel.crashing.org
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707051528.34754.oliver@neukum.org> <20070705134632.GA22177@srcf.ucam.org>
In-Reply-To: <20070705134632.GA22177@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707051609.25887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 5 July 2007 15:46, Matthew Garrett wrote:
> On Thu, Jul 05, 2007 at 03:28:33PM +0200, Oliver Neukum wrote:
> 
> > If, at a minimum, we can determine that we can STD without a freezer.
> > It makes no sense to invest a lot of work to face the same problem
> > again with STD.
> 
> I have a model for STD that avoids the need to freeze the entirity of 
> userspace, but I need to find some more time to flesh it out.

You can just describe it, as far as I'm concerned. :-)

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
