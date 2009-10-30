Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbZJ3DoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbZJ3DoS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 23:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbZJ3DoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 23:44:18 -0400
Received: from kroah.org ([198.145.64.141]:48617 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110AbZJ3DoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 23:44:17 -0400
Date: Thu, 29 Oct 2009 20:44:20 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: manual merge of the net/wireless tree with the
	staging.current tree
Message-ID: <20091030034420.GA16839@kroah.com>
References: <20091030141800.eb72e320.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091030141800.eb72e320.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 30, 2009 at 02:18:00PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net tree got conflicts in
> drivers/staging/rtl8187se/Kconfig and drivers/staging/rtl8192e/Kconfig
> between commit a26961e914c88e3e2ed46ef67f83a33ad7b57c36 ("Staging: fix
> wireless drivers depends") from the staging.current tree and commit
> 125b181aec7a67c71234284ecf6d9c729d05deda ("staging: Add proper selection
> of WIRELESS_EXT and WEXT_PRIV") from the net/wireless tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix
> for a while.

Thanks, the fix looks fine to me.

greg k-h
