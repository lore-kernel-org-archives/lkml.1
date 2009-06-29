Return-Path: <linux-kernel-owner+w=401wt.eu-S1759462AbZF2WSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759462AbZF2WSl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 18:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752771AbZF2WSb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 18:18:31 -0400
Received: from kroah.org ([198.145.64.141]:59455 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbZF2WSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 18:18:30 -0400
Date: Mon, 29 Jun 2009 15:18:26 -0700
From: Greg KH <greg@kroah.com>
To: tridge@samba.org
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       "Eric W. Biederman" <ebiederm@xmission.com>, john.lanza@linux.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Steve French <sfrench@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
       Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] Added CONFIG_VFAT_FS_DUALNAMES option
Message-ID: <20090629221826.GA12781@kroah.com>
References: <19013.8005.541836.436991@samba.org> <m1d48p5dil.fsf@fess.ebiederm.org> <19014.54044.484370.187018@samba.org> <m1vdmh2e26.fsf@fess.ebiederm.org> <19015.482.794111.612472@samba.org> <87ab3sx4ch.fsf@devron.myhome.or.jp> <19016.6463.997760.757811@samba.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19016.6463.997760.757811@samba.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 11:30:39AM +1000, tridge@samba.org wrote:
> Hi Hirofumi-san,
> 
>  > If you want, I have no problem to do. However, I'm not thinking that
>  > part is a bug.  And -stable rule is also "a real bug that bothers
>  > people", but there is even a no bug reporter which tell actual problem.
> 
> ok, then what about pushing the whole patch into -stable?
> 
> The 'bug' in this case is like a security hole, with Microsoft
> demonstrating an active exploit. This falls outside the normal range
> of bug fixes for -stable, but I think you'd have to agree that the
> whole situation is unusual.

I have no objection to take this patch for the -stable releases when it
goes into Linus's tree.  Just forward the git commit ids to
stable@kernel.org and I can take care of it.

thanks,

greg k-h
