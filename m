Return-Path: <linux-kernel-owner+w=401wt.eu-S933034AbYBHFy4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933034AbYBHFy4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 00:54:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752398AbYBHFyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 00:54:45 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:35945 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbYBHFyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 00:54:45 -0500
Date: Thu, 7 Feb 2008 21:47:43 -0800
From: Greg KH <greg@kroah.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Artem.Bityutskiy@nokia.com
Subject: Re: UBI: add mtd_num sysfs attribute
Message-ID: <20080208054743.GA13097@kroah.com>
References: <200802071907.m17J7eYA022058@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802071907.m17J7eYA022058@hera.kernel.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07, 2008 at 07:07:40PM +0000, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/git/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=b6b76ba466bbd47397efad0fdaeaa5ebf7d462c7
> Commit:     b6b76ba466bbd47397efad0fdaeaa5ebf7d462c7
> Parent:     d1f3dd6cc00f5bf744118fb2820ecdf09a1f4b73
> Author:     Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> AuthorDate: Wed Dec 26 13:46:46 2007 +0200
> Committer:  Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> CommitDate: Wed Dec 26 19:15:17 2007 +0200
> 
>     UBI: add mtd_num sysfs attribute
>     
>     Expose number or the underlying MTD device in sysfs.

Can you please add this information to Documentation/ABI/ so that people
know what is going on here?

thanks,

greg k-h
