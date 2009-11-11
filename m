Return-Path: <linux-kernel-owner+w=401wt.eu-S1759050AbZKKVAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759050AbZKKVAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 16:00:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759034AbZKKVAR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 16:00:17 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46629 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759022AbZKKVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 16:00:15 -0500
Date: Wed, 11 Nov 2009 15:51:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2009-11-11
Message-ID: <20091111205141.GK4392@tuxdriver.com>
References: <20091111172255.GH4392@tuxdriver.com> <20091111.112031.184370997.davem@davemloft.net> <20091111.114114.228545645.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111.114114.228545645.davem@davemloft.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 11:41:14AM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 11 Nov 2009 11:20:31 -0800 (PST)
> 
> > From: "John W. Linville" <linville@tuxdriver.com>
> > Date: Wed, 11 Nov 2009 12:22:55 -0500
> > 
> >> P.S.  Due to the aformentioned iwlwifi fix, this will cause -next
> >> conflicts for sfr.  You may want to pull net-2.6 into net-next-2.6 after
> >> pulling this.  The iwlwifi conflicts can be resolved by taking the bigger
> >> hunks...
> > 
> > Yep, I noticed this, I'll sort it out, thanks.
> 
> I just pushed out the merge to net-next-2.6, please double
> check my work.

Found a little merge damage, sent a fixup patch to netdev@vger.kernel.org...

Thanks!  Sorry if I gave bad merge conflict fixup advice...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
