Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZEVIKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZEVIKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753453AbZEVIKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:10:18 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752508AbZEVIKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:10:16 -0400
Date: Fri, 22 May 2009 01:10:15 -0700 (PDT)
Message-Id: <20090522.011015.133460723.davem@davemloft.net>
To: linville@tuxdriver.com
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, abhijeet.kolekar@intel.com,
       reinette.chatre@intel.com
Subject: Re: linux-next: manual merge of the net tree with the tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090522003546.GB2646@tuxdriver.com>
References: <20090521.152511.171736740.davem@davemloft.net>
	<20090521.152910.256913910.davem@davemloft.net>
	<20090522003546.GB2646@tuxdriver.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 21 May 2009 20:35:47 -0400

> I think what Stephen has done is good for now.  I'll probably post
> a pull request for wireless-next-2.6 tommorrow.

Ok.

Once I pull that in I'll pull net-2.6 into net-next-2.6 to resolve
all of the merge issues fully.
