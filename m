Return-Path: <linux-kernel-owner+w=401wt.eu-S1756942AbZCNPvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756942AbZCNPvj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 11:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbZCNPva
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 11:51:30 -0400
Received: from kroah.org ([198.145.64.141]:55698 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752005AbZCNPva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 11:51:30 -0400
Date: Sat, 14 Mar 2009 08:41:57 -0700
From: Greg KH <greg@kroah.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: more than 50 percent of dmesg belongs only to PCI and USB
Message-ID: <20090314154157.GA5864@kroah.com>
References: <1237016485.2935.12.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237016485.2935.12.camel@ht.satnam>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 01:11:25PM +0530, Jaswinder Singh Rajput wrote:
> Can we make dmesg little bit better and remove some noise and put these
> debug messages on /sys/kernel/debug/ :

Are you sure you don't have some debugging options enabled in your
kernel?

Also, patches gladly accepted :)

thanks,

greg k-h
