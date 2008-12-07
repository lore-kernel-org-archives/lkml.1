Return-Path: <linux-kernel-owner+w=401wt.eu-S1753940AbYLGBPO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbYLGBPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 20:15:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753530AbYLGBPA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 20:15:00 -0500
Received: from ns2.suse.de ([195.135.220.15]:34461 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753486AbYLGBPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 20:15:00 -0500
Date: Sat, 6 Dec 2008 17:10:37 -0800
From: Greg KH <gregkh@suse.de>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: convert to list_for_each()
Message-ID: <20081207011037.GA16462@suse.de>
References: <20081206184905.GA19589@orion> <20081206203740.GA2264@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081206203740.GA2264@x200.localdomain>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 06, 2008 at 11:37:40PM +0300, Alexey Dobriyan wrote:
> On Sat, Dec 06, 2008 at 09:49:05PM +0300, Alexander Beregalov wrote:
> 
> No, switch to list_for_each_entry() from the very beginning.

I agree, please use list_for_each_entry() instead.

Also, if you could split this up into two patches?  One for each driver
would be apprecited.

thanks,

greg k-h
