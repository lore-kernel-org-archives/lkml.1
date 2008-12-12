Return-Path: <linux-kernel-owner+w=401wt.eu-S1757381AbYLLILo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381AbYLLILo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 03:11:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750892AbYLLILf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 03:11:35 -0500
Received: from ozlabs.org ([203.10.76.45]:54494 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703AbYLLILe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 03:11:34 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [linux-next][PATCH] cpumask:cpumask_of_node-ia64 fix
Date: Fri, 12 Dec 2008 18:41:24 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: Mike Travis <travis@sgi.com>, "Luck, Tony" <tony.luck@intel.com>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
References: <20081211105721.4FEE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <494093F7.5020000@sgi.com> <20081211132146.4FFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20081211132146.4FFD.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812121841.25429.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 December 2008 15:23:09 KOSAKI Motohiro wrote:
> and my review and test doen't find any problem in your patch.
> Very thanks.
...
> The following is the folded patch of your patch and your over-simplified fix.

Thanks for this.  I do not know how I missed these (I did not have an IA64
cross-compiler then though).

I will fold this fix into the ia64 cpumask_of_node patch.

Thanks,
Rusty.
