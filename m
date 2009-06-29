Return-Path: <linux-kernel-owner+w=401wt.eu-S1758445AbZF2VPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758445AbZF2VPi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 17:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757720AbZF2VPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 17:15:13 -0400
Received: from kroah.org ([198.145.64.141]:45256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757103AbZF2VPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 17:15:12 -0400
Date: Mon, 29 Jun 2009 14:01:44 -0700
From: Greg KH <greg@kroah.com>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: "stable@kernel.org" <stable@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [stable] [PATCH 2.6.30-stable] jfs: fix regression preventing
	coalescing of extents
Message-ID: <20090629210144.GG24106@kroah.com>
References: <1245245721.7926.4.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245245721.7926.4.camel@norville.austin.ibm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 08:35:21AM -0500, Dave Kleikamp wrote:
> Please pick up this patch for the 2.6.30 stable branch.  It has been
> committed to mainline as f7c52fd17a7dda42fc9e88c2b2678403419bfe63.

Now queued up, thanks.

greg k-h
