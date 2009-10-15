Return-Path: <linux-kernel-owner+w=401wt.eu-S935305AbZJOSpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935305AbZJOSpS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 14:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935295AbZJOSpQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 14:45:16 -0400
Received: from kroah.org ([198.145.64.141]:60267 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935284AbZJOSpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 14:45:15 -0400
Date: Thu, 15 Oct 2009 11:32:44 -0700
From: Greg KH <greg@kroah.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>
Subject: Re: Candidate for stable: e1000e: swap max hw supported frame size
 between 82574 and 82583
Message-ID: <20091015183244.GD3921@kroah.com>
References: <4AD33198.6020704@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AD33198.6020704@canonical.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 12, 2009 at 07:39:36AM -0600, Tim Gardner wrote:
> commit a825e00c98a2ee37eb2a0ad93b352e79d2bc1593 seems like a good
> candidate for stable (if you've not already been notified).

Thanks, I have now queued this up.

greg k-h
