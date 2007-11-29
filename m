Return-Path: <linux-kernel-owner+w=401wt.eu-S1762977AbXK2Ujj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762977AbXK2Ujj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 15:39:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759259AbXK2Uj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 15:39:28 -0500
Received: from there.is.no.cabal.ca ([134.117.69.58]:58385 "EHLO
	fattire.cabal.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758786AbXK2Uj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 15:39:27 -0500
Date: Thu, 29 Nov 2007 15:39:26 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: Something similar to inotify in 2.4.
Message-ID: <20071129203926.GB2754@fattire.cabal.ca>
References: <35fbaa3e0711290909k1965ca75v622f7a36e409d57d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fbaa3e0711290909k1965ca75v622f7a36e409d57d@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2007 at 07:09:51PM +0200, Vitaliy Ivanov wrote:
> Hi all,
> 
> Can anyone advice whether there is something similar to inotify in 2.4 kernel?
> 
> Need efficient way to track file system changes.
> 
> Maybe some other tools, approaches under 2.4?
> 

dnotify[1]? but it might make you cry.

cheers,
	Kyle

1.
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=Documentation/dnotify.txt;h=6984fca6002a304272ea3606e0ad1a34568221d6;hb=HEAD
