Return-Path: <linux-kernel-owner+w=401wt.eu-S1756532AbXLBTFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532AbXLBTFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 14:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbXLBTFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 14:05:20 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57718 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXLBTFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 14:05:19 -0500
Date: Sun, 2 Dec 2007 11:08:29 -0800
From: Greg KH <greg@kroah.com>
To: Avi Kivity <avi@qumranet.com>
Cc: stable@kernel.org, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [stable] [PATCH 00/10]: KVM updates for 2.6.23.9 (-stable)
Message-ID: <20071202190829.GA22385@kroah.com>
References: <1196594327338-git-send-email-avi@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1196594327338-git-send-email-avi@qumranet.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2007 at 01:18:37PM +0200, Avi Kivity wrote:
> The following patchset fixes some bugs in KVM for the next 2.6.23.y stable
> release.  Please apply.

I'm guessing that all of these are already upstream in Linus's tree?

If so, can you give me the git commit ids for them all if you happen to
know them, so that I don't have to guess at them?  :)

thanks,

greg k-h
