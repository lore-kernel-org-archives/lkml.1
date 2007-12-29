Return-Path: <linux-kernel-owner+w=401wt.eu-S1756158AbXL2Eja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756158AbXL2Eja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 23:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754473AbXL2EjU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 23:39:20 -0500
Received: from cantor.suse.de ([195.135.220.2]:34633 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753253AbXL2EjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 23:39:19 -0500
Date: Fri, 28 Dec 2007 20:42:00 -0800
From: Greg KH <gregkh@suse.de>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] Use mutex instead of semaphore in driver core
Message-ID: <20071229044200.GA16712@suse.de>
References: <20071229010157.GB2883@darkstar.te-china.tietoenator.com> <1198891742.6821.98.camel@twins> <a8e1da0712281736p6dcc3f05vdb3b8ed9618e0147@mail.gmail.com> <1198892544.6821.103.camel@twins> <a8e1da0712281752q68ec8a98kcc5f84928091a8d2@mail.gmail.com> <1198893445.6821.108.camel@twins> <a8e1da0712281803i11c04b37ic5e92a4c27c79b07@mail.gmail.com> <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0712281836t418881fbi5c8b924ba353bf90@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 10:36:49AM +0800, Dave Young wrote:
> >
> The full boot dmesg with lockdep output is out, there's one warnings in it :

Please fix that warning before the next repost of these patches (along
with fixing the problem of them not being able to be applied and
successfully built at every point in the series...)

thanks,

greg k-h
