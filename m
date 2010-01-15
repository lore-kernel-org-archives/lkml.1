Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932374Ab0AOVrm (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 16:47:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950Ab0AOVrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 16:47:40 -0500
Received: from kroah.org ([198.145.64.141]:40418 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751709Ab0AOVrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 16:47:40 -0500
Date: Fri, 15 Jan 2010 13:37:32 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>
Subject: Re: [PATCH 0/7] General sysfs enhancements
Message-ID: <20100115213732.GA17838@kroah.com>
References: <m1d41g9z3q.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1d41g9z3q.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 11, 2010 at 12:16:09PM -0800, Eric W. Biederman wrote:
> 
> This patchset is built on top of 2.6.33-rc3 +
>   "sysfs: Cache the last sysfs_dirent to improve readdir scalability v2"
> 
> Greg I assume you have that patch somewhere in queue.

It is now applied.

> This patchset contains little cleanups all around sysfs.
> - Some basic cleanups.
> - Some sysfs scaling work 
> - Implementation of sysfs_rename

Care to resend these, as it seems that some needed to be redone.

thanks,

greg k-h
