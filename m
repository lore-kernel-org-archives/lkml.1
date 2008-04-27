Return-Path: <linux-kernel-owner+w=401wt.eu-S1762811AbYD0XPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762811AbYD0XPt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbYD0XPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:15:42 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:41199 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753553AbYD0XPl (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:15:41 -0400
Date: Mon, 28 Apr 2008 09:15:20 +1000
From: David Chinner <dgc@sgi.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Eric Dumazet <dada1@cosmosbay.com>, David Chinner <dgc@sgi.com>,
       xfs-masters@oss.sgi.com, Alexander van Heukelum <heukelum@fastmail.fm>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
Message-ID: <20080427231520.GA103491721@sgi.com>
References: <20080425090901.ca642c4d.randy.dunlap@oracle.com> <48121331.1030204@cosmosbay.com> <1209145675.2005.1249890339@webmail.messagingengine.com> <48121A37.5020504@cosmosbay.com> <20080425191830.GA4898@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425191830.GA4898@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 11:18:30PM +0400, Alexey Dobriyan wrote:
> 
> [PATCH] xfs: remove xfs_log_ticket_zone on rmmod
> 
> Bug introduces in commit eb01c9cd87c7a9998c2edf209721ea069e3e3652
> aka "[XFS] Remove the xlog_ticket allocator"

Oops, My bad.

Thanks for catching this. I've queued it for checkin.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
