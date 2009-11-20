Return-Path: <linux-kernel-owner+w=401wt.eu-S1753760AbZKTPbF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbZKTPbF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 10:31:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753020AbZKTPbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 10:31:04 -0500
Received: from kroah.org ([198.145.64.141]:56441 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945AbZKTPbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 10:31:04 -0500
Date: Fri, 20 Nov 2009 07:30:54 -0800
From: Greg KH <greg@kroah.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>
Subject: Re: [PATCH 2/3] staging/dream: add missing include files
Message-ID: <20091120153054.GA23007@kroah.com>
References: <20091101222717.GB20740@elf.ucw.cz> <20091119225602.GC18710@kroah.com> <20091120105726.GH11212@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091120105726.GH11212@elf.ucw.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20, 2009 at 11:57:26AM +0100, Pavel Machek wrote:
> Where can I get the tree to diff against?
> gregkh-08-staging-2.6.32-rc7-git4.patch just reverts everything.
> 
> I guess I can extract it from
> ://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/series ...

Or grab the linux-next tree and branch from right before the "delete the
drivers/staging/dream/ directory" patch.

thanks,

greg k-h
