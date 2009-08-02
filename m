Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbZHBUMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbZHBUMt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 16:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbZHBUMs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 16:12:48 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36823
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753476AbZHBUMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 16:12:48 -0400
Date: Sun, 02 Aug 2009 13:12:56 -0700 (PDT)
Message-Id: <20090802.131256.210461366.davem@davemloft.net>
To: bzolnier@gmail.com
Cc: pcnet32@verizon.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       error27@gmail.com, corbet@lwn.net, eteo@redhat.com, julia@diku.dk
Subject: Re: [PATCH] pcnet32: remove superfluous NULL pointer check in
 pcnet32_probe1()
From: David Miller <davem@davemloft.net>
In-Reply-To: <200908022207.29942.bzolnier@gmail.com>
References: <200907302319.18150.bzolnier@gmail.com>
	<20090802.123022.148176905.davem@davemloft.net>
	<200908022207.29942.bzolnier@gmail.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Date: Sun, 2 Aug 2009 22:07:29 +0200

> netdev@vger.kernel.org was on cc: for all patches...
> 
> http://marc.info/?l=linux-netdev&m=124898901714229&w=2
> http://marc.info/?l=linux-netdev&m=124898901714236&w=2
> 
> maybe there is some problem with a patchwork setup..

My bad, I misread the CC: list, sorry.
