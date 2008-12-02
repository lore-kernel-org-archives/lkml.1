Return-Path: <linux-kernel-owner+w=401wt.eu-S1753463AbYLBWKS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463AbYLBWKS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:10:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751826AbYLBWKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:10:03 -0500
Received: from kroah.org ([198.145.64.141]:56579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751188AbYLBWKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:10:01 -0500
Date: Tue, 2 Dec 2008 13:27:04 -0800
From: Greg KH <greg@kroah.com>
To: "Luis R. Rodriguez" <lrodriguez@Atheros.com>
Cc: stable@kernel.org, sfr@canb.auug.org.au, ath9k-devel@venema.h4ckr.net,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 0/3] ath9k: several fixes ported to 2.6.27
Message-ID: <20081202212704.GA31723@kroah.com>
References: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1228251082-11677-1-git-send-email-lrodriguez@atheros.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 02, 2008 at 12:51:19PM -0800, Luis R. Rodriguez wrote:
> This fixes a few issues seen on MacBook Pros:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=11811
> 
> I've ported them to 2.6.27 to help with them being applied sooner.

What do you mean by "sooner"?  They need to be in Linus's tree before we
can add them to the 2.6.27-stable tree.  Please let us know when that
happens, and what the git ids of them are, so we can add them to the
next -stable release.

thanks,

greg k-h
