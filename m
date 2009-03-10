Return-Path: <linux-kernel-owner+w=401wt.eu-S1757212AbZCJSy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbZCJSy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 14:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756109AbZCJSxi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 14:53:38 -0400
Received: from kroah.org ([198.145.64.141]:36579 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754207AbZCJSxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 14:53:36 -0400
Date: Tue, 10 Mar 2009 11:27:42 -0700
From: Greg KH <greg@kroah.com>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 00/20] ceph: Ceph distributed file system client
Message-ID: <20090310182742.GB5730@kroah.com>
References: <1236638439-6753-1-git-send-email-sage@newdream.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1236638439-6753-1-git-send-email-sage@newdream.net>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 09, 2009 at 03:40:19PM -0700, Sage Weil wrote:
> This is a patch series for v0.7 of the Ceph distributed file system
> client (against v2.6.29-rc7).
> 
> Changes since v0.6:
>  * Improved (faster) truncate strategy
>  * Moved proc items to sysfs
>  * Bug fixes, performance improvements
> 
> Changes since v0.5:
>  * Asynchronous commit of metadata operations to server
> 
> Please consider for inclusion in mm and/or staging trees.  Review
> and/or comments are most welcome.

If you want it included in the staging tree, then you need to submit
patches that place it under drivers/staging/ :)

thanks,

greg k-h
