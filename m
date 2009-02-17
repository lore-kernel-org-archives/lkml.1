Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZBQDYY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZBQDYY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 22:24:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZBQDXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 22:23:51 -0500
Received: from kroah.org ([198.145.64.141]:35475 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750859AbZBQDXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 22:23:48 -0500
Date: Mon, 16 Feb 2009 19:15:21 -0800
From: Greg KH <greg@kroah.com>
To: Theodore Tso <tytso@mit.edu>, stable@kernel.org,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [stable] [cebbert@redhat.com: Re: Ext4 tree backports for
	2.6.27.13 and 2.6.28.2]
Message-ID: <20090217031521.GB8343@kroah.com>
References: <20090216230104.GG23758@mini-me.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090216230104.GG23758@mini-me.lan>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 06:01:04PM -0500, Theodore Tso wrote:
> Hi,
> 
> Can you please include the patches found in the for-stable and
> for-stable-2.6.27 branches at:
> 
> 	  git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git
> 
> into the next 2.6.28.y and 2.6.27.y kernels, respectively?
> 
> Or do you need me to send them in e-mail format via git
> format-patch/git send-email?  I can do that too if you prefer that.

Yes, please do that, it makes it much easier for our scripts to handle
them that way.

thanks,

greg k-h
