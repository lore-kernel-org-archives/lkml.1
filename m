Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbZA0X6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbZA0X6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:58:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751689AbZA0X6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:58:04 -0500
Received: from kroah.org ([198.145.64.141]:60307 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751839AbZA0X6B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:58:01 -0500
Date: Tue, 27 Jan 2009 15:56:40 -0800
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6-git
Message-ID: <20090127235640.GA10933@kroah.com>
References: <20090127234956.GA10673@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090127234956.GA10673@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 03:49:56PM -0800, Greg KH wrote:
> Here are some USB patches for your 2.6-git tree.
> 
> The largest thing here is a new driver, that was held up on the -rc1
> merge due to a dependancy on some code that had to go into the ARM tree
> first.

Ugh, not ARM, it was PPC, just to be pedantic.

thanks,

greg k-h
