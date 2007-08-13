Return-Path: <linux-kernel-owner+w=401wt.eu-S970495AbXHMPzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970495AbXHMPzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S946637AbXHMOQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 10:16:18 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59033 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S946634AbXHMOQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 10:16:16 -0400
Message-ID: <46C067AE.3090409@s5r6.in-berlin.de>
Date: Mon, 13 Aug 2007 16:16:14 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.6) Gecko/20070802 SeaMonkey/1.1.4
MIME-Version: 1.0
To: David Brownell <david-b@pacbell.net>
CC: joe@perches.com, linux-usb-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, johannes@erdfelt.com,
       akpm@linux-foundation.org
Subject: Re: [linux-usb-devel] [PATCH] [497/2many] MAINTAINERS - USB HUB DRIVER
References: <46bffc57.+VLVIUHqG3mGbW2w%joe@perches.com> <200708130024.23968.david-b@pacbell.net>
In-Reply-To: <200708130024.23968.david-b@pacbell.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Brownell wrote:
> Is there general agreement that these "F:" entries should be used?
> Rather than, say, embedding references in the relevant parts of
> the source tree, adjacent to those files, where they would be more
> visible to people making relevant changes.
> 
> I'm also concerned with the reality that the MAINTAINERS file is
> not accurate.  The $SUBJECT patch is one example; the named maintainer
> is no longer active (in that area, at least) and the named driver is
> not actually separable from the rest of usbcore.  Better IMO to just
> remove the "hub driver" entry.

I don't speak for Joe, but:  If there is a good mapping from MAINTAINERS
to paths then more submitters will use MAINTAINERS more frequently.  A
side effect would be that outdated entries in MAINTAINERS would become
apparent more quickly, and updated more quickly.  Of course that's just
speculation --- but your comment on this "hub driver" entry, prompted by
Joe's patch, seems to support that speculation.
-- 
Stefan Richter
-=====-=-=== =--- -==-=
http://arcgraph.de/sr/
