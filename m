Return-Path: <linux-kernel-owner+w=401wt.eu-S1755485AbZFENYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbZFENYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 09:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754350AbZFENXx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 09:23:53 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37784 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbZFENXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 09:23:52 -0400
Subject: Re: [PATCH 3/5] net: add NL802154 interface for configuration of 
 802.15.4 devices
From: Marcel Holtmann <marcel@holtmann.org>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Sergey Lapin <slapin@ossfans.org>, David Miller <davem@davemloft.net>,
       johannes@sipsolutions.net, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
       sfr@canb.auug.org.au
In-Reply-To: <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
References: <1244168990-28355-4-git-send-email-dbaryshkov@gmail.com>
	 <1244184737.22576.94.camel@johannes.local>
	 <20090605071529.GA7064@doriath.ww600.siemens.net>
	 <20090605.005418.07362083.davem@davemloft.net>
	 <20090605091229.GA25280@doriath.ww600.siemens.net>
	 <20090605094619.GB23085@build.ossfans.org>
	 <bc64b4640906050345t5ed23d7bxc8a777a4a0ada147@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 05 Jun 2009 15:23:17 +0200
Message-Id: <1244208197.23850.22.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

> > Dmitry, please toss all my @siemens.com addresses from all patches, since my
> > access is already disabled and it's pointless to have invalid emails
> > in source tree. Please replace them with @ossfans.org ones.
> 
> Could you please send an incremental patch on top of this serie? I
> hope that my last
> push can be pulled/merged and I don't want to redo all commits.

either start getting used to git-rebase or manual rebase of commits. You
better be familiar with git before asking people to merge. We are
expecting you to provide proper trees to pull from a patches to apply.

And since Dave and Johannes already asked you to fix the __KERNEL__ part
you have to redo the pull request anyway.

Regards

Marcel


